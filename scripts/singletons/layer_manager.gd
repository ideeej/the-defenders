extends Node

const player_characters : int = 5
const enemy_characters : int = 6
const player_castles : int = 7
const enemy_castles : int = 8


func calculate_layers(template):
	# PS.
	# Do not touch.
	# Sincerely, dev
	
	var layers : Dictionary = {
		"own": 0,
		"enemy": 0
	}
	
	if template.is_enemy:
		layers.own = pow(2, enemy_characters) + pow(2, enemy_castles)
		layers.enemy = pow(2, player_characters) + pow(2, player_castles)
	else:
		layers.own = pow(2, player_characters) + pow(2, player_castles)
		layers.enemy = pow(2, enemy_characters) + pow(2, enemy_castles)
	
	return layers

func get_layer_value(layer):
	return pow(2, layer)
