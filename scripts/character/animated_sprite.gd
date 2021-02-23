extends AnimatedSprite

var width : float
var height : float


func initialize(template):
	setup_animation_direction(template.is_enemy)
	setup_animation_frames(template.animation_frames)
	set_animation("idle")
	set_playing(true)
	
	width = get_frame_width()
	height = get_frame_height()



func setup_animation_direction(is_enemy):
	if is_enemy:
		flip_horizontal()


func setup_animation_frames(sprite_frames):
	self.frames = sprite_frames


func set_animation(animation_name):
	self.animation = animation_name


func set_playing(on):
	self.playing = on


func flip_horizontal():
	self.flip_h = !self.flip_h


func get_frame_width():
	return self.frames.get_frame(self.animation, self.frame).get_width()


func get_frame_height():
	return self.frames.get_frame(self.animation, self.frame).get_height()
