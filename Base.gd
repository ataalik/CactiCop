extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var helper_functions

enum MODES{
  hand_mode,
  water_mode,
  fertilizer_mode
}

export var water_cursor : Resource
export var fertilizer_cursor : Resource 
export var water_cursor_clicked : Resource
export var fertilizer_cursor_clicked : Resource 
export var hand_cursor : Resource 

var potScene = preload("res://Pot.tscn")

var current_mode

# Rules for evil cacti
var current_rules = []

export var base_evil_time = 60
var current_evil_time
var rand_evil_offset

var Items

var cursor_change = false

var level = 0 #How hard the game is

# Called when the node enters the scene tree for the first time.
func _ready():
	helper_functions = get_node("/root/helper_functions")
	current_mode = MODES.hand_mode
	Input.set_custom_mouse_cursor(hand_cursor)
	for x in range(0,10):
		current_rules = helper_functions.make_evil_rule(current_rules)

	current_evil_time = 0
	
	rand_evil_offset = helper_functions.get_random(15)
	Items = get_node("Items")
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Change the cursor image according to the mode we are in. 
	if(current_mode == MODES.water_mode):
		if cursor_change:
			Input.set_custom_mouse_cursor(water_cursor_clicked)
		else:
			Input.set_custom_mouse_cursor(water_cursor)
	elif(current_mode == MODES.fertilizer_mode):
		if cursor_change:
			Input.set_custom_mouse_cursor(fertilizer_cursor_clicked)
		else:
			Input.set_custom_mouse_cursor(fertilizer_cursor)
	elif(current_mode == MODES.hand_mode):
		Input.set_custom_mouse_cursor(hand_cursor)
	
	current_evil_time = current_evil_time + delta
	
	
	#create new rule at interval

	if(current_evil_time > (base_evil_time + rand_evil_offset)): 
		rand_evil_offset = helper_functions.get_random(15) # Set random interval

		#Creates a new rule
		current_rules = helper_functions.make_evil_rule(current_rules)
		
		current_evil_time = 0 

		#$LowerHUD/Evil.text = String(current_rules)
	# Change back to hand mode when right click is pressed. 
	if Input.is_action_pressed("hand_mode") and current_mode != MODES.hand_mode:
		current_mode = MODES.hand_mode
		
	if Input.is_action_just_released("left_click"):
		if not Input.set_custom_mouse_cursor(hand_cursor):
			cursor_change = true
			$CursorChange.start()
		pass
	pass
	
func find_evil(): #Finding if there are Evil Cacti
	#OBS! NEED to not use arrays directly from cacties!
	var all_cacti = Items.get_children()
	var temp_cacti = []
	for cacti in all_cacti:
		temp_cacti.append(cacti.cacti_dict)
	for cacti in temp_cacti:
		for rule in current_rules:
			if rule["cactus_color"] == cacti["cactus_color"]:
				#cacti.evil = true
				if rule["hand_type"] == cacti["hand_type"]:
						#cacti.evil = true
						if rule["hat_type"] == cacti["hat_type"]:
							#cacti.evil = true
							if rule["hat_color"] == cacti["hat_color"]:
								#cacti.evil = true
								pass

func _on_WateringButton_pressed():
	print("Watering mode")
	current_mode = MODES.water_mode
	pass # Replace with function body.


func _on_FertilizerButton_pressed():
	print("Fertilizer mode")
	current_mode = MODES.fertilizer_mode
	pass # Replace with function body.
	
func add_pot():
	
	var p = potScene.instance()
	Items.add_child(p)
	p.position = get_node("Node2D/new_cacti").position

func _on_CactiCreator_timeout():
	print("Adding pot")
	add_pot()
	pass # Replace with function body.


func _on_CursorChange_timeout():
	cursor_change = false
	pass # Replace with function body.
