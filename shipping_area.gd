extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum STAGES{
  good,
  bad
}

export var box_label = "Box"

# Called when the node enters the scene tree for the first time.
func _ready():
  get_node("Label").set_text(box_label)
  #	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
