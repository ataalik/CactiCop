extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var green = Color(0,255,0)
var red = Color(255,0,0)
var blue = Color(0,0,255)
var yellow = Color(255,255,0)
var cactusColor = yellow
var hatColor = blue
var needs_water = true
var needs_fert = true
var root

# Growth stages
enum STAGES{
  seedling,
  sapling,
	branch,
	mature
}

# All times in seconds
# Base water and fertilizer need times
export var water_time_constant = 5
export var fertilizer_time_constant = 10
# Max bound of random value to add to water/fert times
export var random = 30
var water_time
var fertilizer_time

# Max health
export var max_health = 100
var current_health

# Growth time needed
export var growth_time = 20
export var growth_threshold = 80 
var current_growth
var current_stage

# For drag and drop 
var mouse_pressed
var dragging

# Sprite related vars
export var cactus_types = ["OneArm", "ThreeArm", "TwoArm"] # Should change if we add more arms
var hat_types_no
var cactus_sprite
var hat_sprite
var current_hands
var current_hat

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cactus.modulate = cactusColor
	$Hat.modulate = hatColor
	root = get_node("/root/Base")
	
	water_time = water_time_constant
	fertilizer_time = fertilizer_time_constant
	current_growth = 0
	current_health = max_health
	current_stage = STAGES.seedling

	cactus_sprite = get_node("Cactus")
	

	hat_sprite = get_node("Hat")
	hat_types_no = hat_sprite.get_sprite_frames().get_frame_count(hat_sprite.get_animation())


	current_hands = get_random(cactus_types.size())
	cactus_sprite.set_animation(cactus_types[current_hands])
	cactus_sprite.set_frame(current_stage)

	current_hat = get_random(hat_types_no)
	hat_sprite.set_frame(current_hat)
	hat_sprite.set_visible(false)

	print(current_hands)
	print(current_hat)
	mouse_pressed = false
	dragging = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if we don't need something decrement our need cooldown
	if(current_stage != STAGES.mature):
		if(needs_water == false):
			water_time = water_time - delta	

		if(needs_fert == false):
			fertilizer_time = fertilizer_time - delta

		# if we need both decrease health 2, if we need one decrease 1, if we need none increase 1
		if(needs_fert && needs_water):
			current_health = current_health - (2 * delta)
		elif(needs_fert || needs_water):
			current_health = current_health - delta
		else:
			current_health = current_health + delta

		# correct overflow of health
		if(current_health > max_health):
			current_health = max_health
		elif(current_health < 0):
			current_health = 0

		# grow if health bigger then growth threshold
		if(current_health > growth_threshold):
			current_growth = current_growth + delta 
		
		if(current_growth >= growth_time):
			grow()

		# update need status
		if(water_time <= 0):
			needs_water = true 
		if(fertilizer_time <0):
			needs_fert = true
			
		if(dragging):
				set_position(get_viewport().get_mouse_position())
	pass

func _input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
		and event.pressed:
		mouse_pressed = event.pressed
		if(root.current_mode == root.MODES.water_mode):
			water()
		elif(root.current_mode == root.MODES.fertilizer_mode):
			fertilize()
		elif(root.current_mode == root.MODES.hand_mode):
			# Debug
			dragging = !dragging
			print("Water time: " + String(water_time) + "\nNeeds water: " + String(needs_water))
			print("Fertilizer time: " + String(fertilizer_time) + "\nNeeds fert: " + String(needs_fert))
			print("Current health: " + String(current_health))
			print("current_growth: " + String(current_growth))
			print("Current stage: " + String(current_stage))

func water():
	if(needs_water):
		needs_water = false
		water_time = water_time_constant + (randi() % random)
	pass

func fertilize():
	if(needs_fert):
		needs_fert = false
		fertilizer_time = fertilizer_time_constant + (randi() % random)
	pass

func grow():
	# TODO change sprite
	current_stage = current_stage + 1
	cactus_sprite.set_frame(current_stage)
	if(current_stage == STAGES.mature):
		hat_sprite.set_visible(true)
	current_growth = 0

func ship(area_name):
	# TODO implement this. Check if plant was evil. Do things like adjusting score or informing players of wrong decision.
	print("shipping to " + area_name)
	pass

func _on_Pot_area_entered(area):
	if(area.name == "real_cacti" || area.name == "fake_cacti"):
		ship(area.name)
	pass # Replace with function body.


func get_random(NR): #Randomize a Dir-number
    randomize()
    return randi()%NR