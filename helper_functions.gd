extends Node

export var hat_types_no = 9
export var cactus_types = ["OneArm", "ThreeArm", "TwoArm"]

var green = Color(0,128,0)
var red = Color(128,0,0)
var blue = Color(0,0,128)
var yellow = Color(128,128,0)

var colors = [green, red, blue, yellow]
var hats = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

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
	var hat_type = get_random(hats.size())

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

# Create a new rule
func make_evil_rule(current_rules):
	
	if(current_rules.size() >= 3):
		current_rules.pop_front()
	
	var new_rule = {}

	# Rule level determines the depth of evil cacti rule
	# level 0 = color level 1 arm no level 2 hat type
	var rule_level = get_random(3)

	var temp_colors = colors.duplicate(true)
	var temp_arms = cactus_types.duplicate(true)
	var temp_hats = hats.duplicate(true)
	
	# If the rule level is 0 make sure that no other rule has the same rule on 
	# cactus color
	if(rule_level == 0):
		for rule in current_rules:
			temp_colors.erase(rule.cactus_color)
		if(temp_colors.size() != 0):
			var new_color = get_random(temp_colors.size())
			new_color = temp_colors[new_color]
			new_rule["cactus_color"] = new_color
			new_rule["rule_level"] = 0
		
		current_rules.append(new_rule)
	# If the rule level is 1 make sure that no other rule has the same rule on 
	# cactus color 
	elif(rule_level == 1):
		for x in range(0,current_rules.size()):
			if current_rules[x].rule_level == 0:
				temp_colors.erase(current_rules[x].cactus_color)
			elif current_rules[x].rule_level == 1:
				temp_arms.erase(current_rules[x].hand_type)
		
		if(temp_colors.size() != 0):
			var new_color = get_random(temp_colors.size())
			new_color = temp_colors[new_color]
			new_rule["cactus_color"] = new_color
		
		if(temp_arms.size() != 0):
			var new_arms = get_random(temp_arms.size())
			new_arms = temp_arms[new_arms]
			new_rule["hand_type"] = new_arms
			new_rule["rule_level"] = 1

		current_rules.append(new_rule)
	elif(rule_level == 2):
		for x in range(0,current_rules.size()):
			if current_rules[x].rule_level == 0:
				temp_colors.erase(current_rules[x].cactus_color)
			elif current_rules[x].rule_level == 1:
				temp_arms.erase(current_rules[x].hand_type)
			elif current_rules[x].rule_level == 2:
				temp_arms.erase(current_rules[x].hat_type)
		
		if(temp_colors.size() != 0):
			var new_color = get_random(temp_colors.size())
			new_color = temp_colors[new_color]
			new_rule["cactus_color"] = new_color
		
		if(temp_arms.size() != 0):
			var new_arms = get_random(temp_arms.size())
			new_arms = temp_arms[new_arms]
			new_rule["hand_type"] = new_arms
		
		if(temp_hats.size() != 0):
			var new_hat = get_random(temp_hats.size())
			new_hat = temp_hats[new_hat]
			new_rule["hat_type"] = new_hat
			new_rule["rule_level"] = 2
		
		current_rules.append(new_rule)
	
	return current_rules

func generate_evil(current_rules):
	if(current_rules.size() == 3):
		current_rules.pop_front()
	var evil_cacti = generate_cactus()
	
	current_rules.append(evil_cacti)

	return current_rules
