extends Area2D

var parent : KinematicBody2D

func _ready():
	parent = get_parent()


func setup_extents(extents):
	$collider.shape = RectangleShape2D.new()
	$collider.shape.extents = extents


func offset(_offset):
	translate(_offset * parent.direction)


func setup_layers(own, enemy):
	set_collision_layer(own)
	set_collision_mask(enemy)


func get_enemies():
	return get_overlapping_bodies()


func has_enemies():
	return get_enemies().size() > 0

