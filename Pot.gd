extends Area2D

var evil = false #Debugging the Evil functions
var needs_water = true
var needs_fert = true
var root
var helper_functions


# Growth stages
enum STAGES{
  seedling,
  sapling,
	branch,
	mature
}

# All times in seconds
# Base water and fertilizer need times
export var water_time_constant = 30
export var fertilizer_time_constant = 30
# Max bound of random value to add to water/fert times
export var random = 30
var water_time
var fertilizer_time

# Max health
export var max_health = 100
var current_health

# Growth time needed
export var growth_time = 25
export var growth_threshold = 80
var current_growth
var current_stage

# For drag and drop 
var mouse_pressed
var dragging
var inside_area = null
# Sprite related vars

var cacti_dict

var thumbScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	helper_functions = get_node("/root/helper_functions")
	root = get_node("/root/Base")
	water_time = water_time_constant
	fertilizer_time = fertilizer_time_constant
	current_growth = 0
	current_health = max_health
	current_stage = STAGES.seedling

	thumbScene = preload("res://Thumbs.tscn")
	
	cacti_dict = helper_functions.generate_cactus()

	$Cactus.set_animation(cacti_dict["hand_type"])
	$Cactus.set_frame(current_stage)
	
	$Hat.set_frame(cacti_dict["hat_type"])
	
	$Cactus.modulate = cacti_dict["cactus_color"]
	$Dead.modulate = cacti_dict["cactus_color"]
	$Hat.modulate = cacti_dict["hat_color"]

	$Hat.set_visible(false)
	
	mouse_pressed = false
	dragging = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var current_rules = root.current_rules
	check_evil(current_rules)
	
	

	if(current_stage != STAGES.mature):
		# if we don't need something decrement our need cooldowns
		if(needs_water == false):
			water_time = water_time - delta	

		if(needs_fert == false):
			fertilizer_time = fertilizer_time - delta

		# if we need both decrease health 2, if we need one decrease 1
		# if we need none increase 1
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
			if $MinusPoints.is_stopped():
				$MinusPoints.start()
		if(fertilizer_time <0):
			needs_fert = true

			if $MinusPoints.is_stopped():
				$MinusPoints.start()
		$NeedsFertilizer.visible = needs_fert
		$NeedsWater.visible = needs_water
	else:
		$NeedsFertilizer.visible = needs_fert
		$NeedsWater.visible = needs_water
	
	if(!dragging && inside_area != null):
		ship(inside_area)

	if(dragging) and helper_functions.pickedPot == self.name:
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
			
			helper_functions.pickedPot = self.name
			
			dragging = !dragging
			
			print("Water time: " + String(water_time) + "\nNeeds water: " + String(needs_water))
			print("Fertilizer time: " + String(fertilizer_time) + "\nNeeds fert: " + String(needs_fert))
			print("Current health: " + String(current_health))
			print("current_growth: " + String(current_growth))
			print("Current stage: " + String(current_stage))
			print(cacti_dict)
			print("ebil? " + String(evil))
			
func water():
	if(needs_water):
		needs_water = false
		$Warning.visible = false
		water_time = water_time_constant + helper_functions.get_random(30) - (root.level * 3)

func fertilize():
	if(needs_fert):
		needs_fert = false
		$Warning.visible = false
		fertilizer_time = fertilizer_time_constant + helper_functions.get_random(30) - (root.level * 3)

func grow():
	current_stage = current_stage + 1
	$Cactus.set_frame(current_stage)
	if(current_stage == STAGES.mature):
		$Hat.set_visible(true)
	current_growth = 0

func ship(area_name):
	# TODO Do things like adjusting score 
	# or informing players of wrong decision.
	# and delete cacti
	if(evil && area_name == "fake_cacti") || \
		(!evil && area_name == "real_cacti" && current_stage == STAGES.mature):
		helper_functions.points += 20
		helper_functions.shipping_confirmation(area_name,"good")
		root.shipped_counter += 1
		var t = thumbScene.instance()
		get_node("/root").add_child(t)
		t.position = position
		
	else:
		helper_functions.points -= 20
		helper_functions.strikes -= 1
		var t = thumbScene.instance()
		get_node("/root").add_child(t)
		t.position = position
		t.good = false
	queue_free()

func _on_Pot_area_entered(area):
	if(area.name == "real_cacti" || area.name == "fake_cacti"):
		inside_area = area.name
		#$CollisionShape2D.disabled = true

func _on_Pot_area_exited(area):

	if(area.name == "real_cacti" || area.name == "fake_cacti"):
		inside_area = null

func check_evil(current_rules): #Finding if there are Evil Cacti
	for rule in current_rules:
		if rule["rule_level"] == 0:
			if rule["cactus_color"] == cacti_dict["cactus_color"]:
				evil = true
		if rule["rule_level"] == 1:
			if rule["cactus_color"] == cacti_dict["cactus_color"] && \
			rule["hand_type"] == cacti_dict["hand_type"]:
				evil = true
		if rule["rule_level"] == 2:
			if rule["cactus_color"] == cacti_dict["cactus_color"] && \
			rule["hand_type"] == cacti_dict["hand_type"] && \
			rule["hat_type"] == cacti_dict["hat_type"]:
				evil = true

func _on_MinusPoints_timeout():
	if needs_fert or needs_water:
		helper_functions.points -= 5
		$Warning.visible = true
	
	
	pass # Replace with function body.

	pass # Replace with function body.
