extends Node

export var hat_types_no = 9
export var cactus_types = ["OneArm", "ThreeArm", "TwoArm"]

var green = Color(0,255,0)
var red = Color(255,0,0)
var blue = Color(0,0,255)
var yellow = Color(255,255,0)

var colors = [green, red, blue, yellow]

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_random(NR): #Randomize a Dir-number
	randomize()
	return randi()%NR

func generate_cactus():
	var hat_type = get_random(hat_types_no)

	var current_hands_no = get_random(cactus_types.size())
	var hand_type = cactus_types[current_hands_no]
	
	var temp_colors = colors.duplicate(true)
	var cactus_color = get_random(temp_colors.size())
	temp_colors.remove(cactus_color)
	var hat_color = get_random(temp_colors.size())
	var cacti_dictionary = {
		"cactus_color" : colors[cactus_color],
		"hand_type" : hand_type,
		"hat_type" : hat_type,
		"hat_color" : temp_colors[hat_color]
	}
	return cacti_dictionary

func generate_evil(current_rules):
	if(current_rules.size() == 3):
		current_rules.pop_front()

	var evil_cacti = generate_cactus()

	current_rules.append(evil_cacti)

	return current_rules
