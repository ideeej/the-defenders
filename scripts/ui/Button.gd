extends Button

export(Resource) var template : Resource

onready var template_scene : PackedScene = preload("res://template_scenes/Character.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	connect("button_down", self, "spawn")
	icon = template.thumbnail

func spawn():
	var instance : KinematicBody2D = template_scene.instance()
	
	instance.template = template
	
	var rn = rng.randi_range(-16, 16)
	
	if template.is_enemy:
		instance.position = Vector2(100, 400+rn)
	else:
		instance.position = Vector2(1000, 400+rn)
	
	# im sorry
	get_parent().get_parent().get_parent().get_parent().add_child(instance)
