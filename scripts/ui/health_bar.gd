extends TextureProgress


var parent : KinematicBody2D

var max_health : float
var health : float
var frame_width : float
var frame_height : float

func _ready():
	parent = get_parent()


func _process(_delta):
	self.health = parent.get_health()
	self.max_health = parent.get_max_health()
	
	self.frame_width = parent.sprite_width
	self.frame_height = parent.sprite_height
	
	# Offset a bit up
	self.rect_position = Vector2(-self.frame_width/2, -self.frame_height*2)
	self.max_value = self.frame_width * 0.8
	
	if self.health > 0:
		self.value = self.max_value * (self.health / self.max_health)
	else:
		self.value = 0

