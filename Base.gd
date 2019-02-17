extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var helper_functions

enum MODES{
  hand_mode,
  water_mode,
  fertilizer_mode,
  pot_mode
}

export var water_cursor : Resource
export var fertilizer_cursor : Resource 
export var water_cursor_clicked : Resource
export var fertilizer_cursor_clicked : Resource 
export var hand_cursor : Resource 
export var pot_cursor : Resource

var potScene = preload("res://Pot.tscn")


var current_mode

# Rules for evil cacti
var current_rules = []

export var base_evil_time = 100 # base seconds for new rule
var current_evil_time # current evil timer
var rand_evil_offset  # offset for evil timer 

var Items

var cursor_change = false

var level = 0 #How hard the game is
var shipped_counter = 0 # Successfully shipped cacti
export var level_threshold = 10 # how many cacti we need to ship to go to the next level

# Called when the node enters the scene tree for the first time.
func _ready():
	helper_functions = get_node("/root/helper_functions")
	current_mode = MODES.hand_mode
	Input.set_custom_mouse_cursor(hand_cursor)
	for x in range(0,2):
		current_rules = helper_functions.make_evil_rule(current_rules)

	current_evil_time = 0
	
	rand_evil_offset = helper_functions.get_random(15)
	Items = get_node("Items")
	
	$Guitar.play()
	
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
	elif(current_mode == MODES.pot_mode):
		Input.set_custom_mouse_cursor(pot_cursor)
	current_evil_time = current_evil_time + delta
	
	
	#create new rule at interval

	if(current_evil_time > (base_evil_time + rand_evil_offset)): 
		rand_evil_offset = helper_functions.get_random(15) # Set random interval

		#Creates a new rule
		current_rules = helper_functions.make_evil_rule(current_rules)
		var temp_time = level * 5
		if(temp_time > 80):
			temp_time = 80
		current_evil_time = temp_time
		$LowerHUD/WarantUpdate.visible = true
		$LowerHUD/WarantUpdate/HideWarrantUpdate.start()

		#$LowerHUD/Evil.text = String(current_rules)
	# Change back to hand mode when right click is pressed. 
	if Input.is_action_pressed("hand_mode") and current_mode != MODES.hand_mode:
		current_mode = MODES.hand_mode
		
	if Input.is_action_just_pressed("left_click"):
		if not Input.set_custom_mouse_cursor(hand_cursor):
			cursor_change = true
			$CursorChange.start()
			if current_mode == MODES.water_mode:
				$wateringSound.play()
			if current_mode == MODES.fertilizer_mode:
				$FertilizingSound.play()
			if current_mode == MODES.pot_mode:
				add_pot()
				
		pass
	$LowerHUD/Instructions.add_text(current_rules)
	$LowerHUD/points.text = str(helper_functions.points)
	$LowerHUD/strikes.text = str(helper_functions.strikes)
	
	if helper_functions.points < -100 or helper_functions.strikes <= 0:
		get_tree().change_scene("res://GameOver.tscn")
	
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
	p.position = get_viewport().get_mouse_position()

func _on_CursorChange_timeout():
	cursor_change = false
	pass # Replace with function body.


func _on_PotButton_pressed():
	print("Pot mode")
	current_mode = MODES.pot_mode
	pass # Replace with function body.


func _on_HideWarrantUpdate_timeout():
	$LowerHUD/WarantUpdate.visible = false
	pass # Replace with function body.
