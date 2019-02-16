extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_text(dict):
	if page >= len(dict):
		page = page - 1
	if page < 0:
		page = 0
	else:
		var desc_string = ""
<<<<<<< HEAD
		
=======
>>>>>>> e0ed2651799a0d71c85db7265cca691c11022388
		if dict[page]["rule_level"] == 0:
			desc_string = get_color(dict[page]["cactus_color"])
			desc_string = desc_string + "\n\n\nany hat"
		if dict[page]["rule_level"] == 1:
			desc_string = get_color(dict[page]["cactus_color"])
			desc_string = desc_string + "\n" + str(dict[page]["hand_type"])
			desc_string = desc_string + "\n\nany hat"
		if dict[page]["rule_level"] == 2:
			desc_string = get_color(dict[page]["cactus_color"])
			desc_string = desc_string + "\n" + str(dict[page]["hand_type"])
			desc_string = desc_string + "\n\n" + str(get_hat(dict[page]["hat_type"]))
		$Base/desc.text = str(desc_string)
	pass
	
func get_color(color):#Converting colors to text
	"""var green = Color(0,128,0)
	var red = Color(128,0,0)
	var blue = Color(0,0,128)
	var yellow = Color(128,128,0)"""
	if color == Color(0,128,0):
		return("Green")
	if color == Color(128,0,0):
		return("Red")
	if color == Color(0,0,128):
		return("Blue")
	if color == Color(128,128,0):
		return("Yellow")
	pass

func get_hat(hatNr):#Converting hat number to name
	if hatNr == 0:
		return"Fez"
	if hatNr == 1:
		return"Prop. cap"
	if hatNr == 2:
		return"Santa hat"
	if hatNr == 3:
		return"Cap"
	if hatNr == 4:
		return"Boot"
	if hatNr == 5:
		return"Sombrero"
	if hatNr == 6:
		return"DunceHat"
	if hatNr == 7:
		return"Top Hat"
	if hatNr == 8:
		return"Cowboy hat"
	if hatNr == 9:
		return"Taxi Cap"
	
	pass


func _on_Next_Page_button_up():
	$Paperflip.play()
	page += 1
	#$Base/Info.text = ("Next Page")
	pass # Replace with function body.


func _on_Prev_Page_button_up():
	$Paperflip.play()
	page -= 1
	#$Base/Info.text = ("Prev Page")
	pass # Replace with function body.
