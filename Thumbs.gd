extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var good = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if good:
		$Bad.visible = false
	else:
		$Good.visible = false

	pass


func _on_Timer_timeout():
	self.queue_free()
	pass # Replace with function body.
