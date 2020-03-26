extends TextureProgress


var parent : KinematicBody2D

var max_health : float
var health : float


func _ready():
	parent = get_parent()
	


func _process(_delta):
	update_player_data()
	
	var frame_height = parent.get_node("animated_sprites").get_frame_height()
	
	rect_position = Vector2(0, -frame_height)
	max_value = parent.get_node("animated_sprites").get_frame_width() * 0.8
	
	if !health == 0:
		value = max_value * (health / max_health)
	else:
		value = 0


func update_player_data():
	health = parent.get_health()
	max_health = parent.get_max_health()

