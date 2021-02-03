extends Area2D

var parent : KinematicBody2D

var width : float
var height: float

func _ready():
	parent = get_parent()


func initialize(stats, collider_layers):
	setup_extents(self.width+stats.vision_range,  self.height)
	offset(Vector2(self.width/2, 0) + Vector2(stats.vision_range, 0))
	setup_layers(collider_layers)



func setup_extents(width, height):
	self.width = width
	self.height = height
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

