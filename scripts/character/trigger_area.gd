extends Area2D

var parent : KinematicBody2D

var width : float
var height: float

func _ready():
	parent = get_parent()


# A bit clunky, not gonna lie...
func initialize(extent, collider_layers):
	self.width = parent.animated_sprite.width
	self.height = parent.animated_sprite.height
	
	setup_layers(collider_layers)
	setup_extents(self.width+extent, self.height)
	offset(Vector2((self.width/2)+extent, 0))




func setup_extents(_width, _height):
	self.width = _width
	self.height = _height
	$collider.shape = RectangleShape2D.new()
	$collider.shape.extents = Vector2(self.width, self.height)


func offset(_offset):
	translate(_offset * parent.direction)


func setup_layers(layers):
	set_collision_layer(layers.own)
	set_collision_mask(layers.enemy)


func get_enemies():
	return get_overlapping_bodies()


func has_enemies():
	return get_enemies().size() > 0

