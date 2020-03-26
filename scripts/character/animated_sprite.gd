extends AnimatedSprite

var parent : KinematicBody2D

func _ready():
	parent = get_parent()


func setup_animation_direction(template):
	if !template.is_enemy:
		flip_h()


func setup_animation_frames(sprite_frames):
	frames = sprite_frames


func set_animation(animation_name):
	animation = animation_name


func set_playing(on):
	playing = on


func flip_h():
	flip_h = true


func get_frame_width():
	return frames.get_frame(animation, frame).get_width()


func get_frame_height():
	return frames.get_frame(animation, frame).get_height()




