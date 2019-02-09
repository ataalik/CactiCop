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
# Called when the node enters the scene tree for the first time.
func _ready():
	$Cactus.modulate = cactusColor
	$Hat.modulate = hatColor
	root = get_node("/root/Base")
	
	water_time = water_time_constant
	fertilizer_time = fertilizer_time_constant
	
	current_health = max_health
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if we don't need something decrement our need cooldown
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

	# update need status
	if(water_time <= 0):
		needs_water = true 
	if(fertilizer_time <0):
		needs_fert = true
	
	pass

func _input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
		if(root.current_mode == root.MODES.water_mode):
			water()
		elif(root.current_mode == root.MODES.fertilizer_mode):
			fertilize()
		elif(root.current_mode == root.MODES.hand_mode):
			# Debug
			print("Water time: " + String(water_time) + "\nNeeds water: " + String(needs_water))
			print("Fertilizer time: " + String(fertilizer_time) + "\n Needs fert: " + String(needs_fert))
			print("Current health: " + String(current_health))
	#	return(self) # returns a reference to this node

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

