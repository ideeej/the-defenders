extends TextureProgress


var parent : KinematicBody2D

var max_health : float
var health : float


func _ready():
	parent = get_parent()
	


func _process(_delta):
	update_player_data()
	
	var animated_sprites = parent.get_node("animated_sprites")
	var frame_height = animated_sprites.height
	var frame_width = animated_sprites.width
	
	rect_position = Vector2(-frame_width/2, -frame_height*2)
	max_value = frame_width * 0.8
	
	if !health == 0:
		value = max_value * (health / max_health)
	else:
		value = 0


func update_player_data():
	health = parent.get_health()
	max_health = parent.get_max_health()

