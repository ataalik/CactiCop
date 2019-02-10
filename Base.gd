extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum MODES{
  hand_mode,
  water_mode,
  fertilizer_mode
}

export var water_cursor : Resource
export var fertilizer_cursor : Resource 
export var hand_cursor : Resource 

var potScene = preload("res://Pot.tscn")

var current_mode 

# Called when the node enters the scene tree for the first time.
func _ready():
	current_mode = MODES.hand_mode
	Input.set_custom_mouse_cursor(hand_cursor)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Change the cursor image according to the mode we are in. 
	if(current_mode == MODES.water_mode):
		Input.set_custom_mouse_cursor(water_cursor)
	elif(current_mode == MODES.fertilizer_mode):
		Input.set_custom_mouse_cursor(fertilizer_cursor)
	elif(current_mode == MODES.hand_mode):
		Input.set_custom_mouse_cursor(hand_cursor)
		
	# Change back to hand mode when right click is pressed. 
	if Input.is_action_pressed("hand_mode") and current_mode != MODES.hand_mode:
		current_mode = MODES.hand_mode
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
	var Items = get_node("Items")
	var p = potScene.instance()
	Items.add_child(p)
	p.position = get_node("Node2D/real_cacti").position
func _on_CactiCreator_timeout():
	print("Adding pot")
	add_pot()
	pass # Replace with function body.
