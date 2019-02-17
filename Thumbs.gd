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
		if helper_functions.get_random(10) == 1:
			if $ThereHeGoes.playing == false:
				$ThereHeGoes.play()
	else:
		$Good.visible = false
		if helper_functions.get_random(10) == 1:
			if $CheckTheRules.playing == false:
				$CheckTheRules.play()
	pass


func _on_Timer_timeout():
	if $CheckTheRules.playing == false and $ThereHeGoes.playing == false:
		self.queue_free()
	pass # Replace with function body.


func _on_ThereHeGoes_finished():
	self.queue_free()
	pass # Replace with function body.


func _on_CheckTheRules_finished():
	self.queue_free()
	pass # Replace with function body.
