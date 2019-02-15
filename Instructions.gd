extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Next_Page_button_up():
	$Base/Info.text = ("Next Page")
	pass # Replace with function body.


func _on_Prev_Page_button_up():
	$Base/Info.text = ("Prev Page")
	pass # Replace with function body.
