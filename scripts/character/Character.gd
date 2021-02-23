extends KinematicBody2D


onready var animated_sprite = $animated_sprite

export(Resource) var character_data : Resource

var stats : Resource # from character data
var state : String

var sprite_width : float
var sprite_height : float


# Actual character health
var health : float

var time : float = 0
var next_attack_time : float = 0
var is_attacking: bool = false
var direction : int


func _ready():
	self.stats = character_data.stats
	self.health = stats.health
	
	# Manually setting the character direction here
	# It's completely fine, but I don't like this
	if self.character_data.is_enemy:
		self.direction = -1
	else:
		self.direction = 1
	
	
	var collider_layers : Dictionary = layer_manager.calculate_layers(character_data)
	set_collision_layer(collider_layers.own)
	set_collision_mask(collider_layers.enemy)
	
	
	var anim = $animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	$animated_sprite.initialize(character_data)
	
	self.sprite_width = $animated_sprite.width
	self.sprite_height = $animated_sprite.height
	$collider.setup_extents(self.sprite_width, self.sprite_height)
	
	
	$vision_area.initialize(self.stats.vision_range, collider_layers)
	$attack_area.initialize(self.stats.attack_area, collider_layers)


func _process(delta):
	pass
	


func _physics_process(delta):
	if !$vision_area.has_enemies():
		move(delta)
	else:
		try_attack()
	
	state = $animated_sprite.animation
	
	time += delta


func _on_animation_finished():
	if $animated_sprite.animation == "attack":
		attack()
	
	if $animated_sprite.animation == "death":
		queue_free()


func set_animation(anim_name):
	if !$animated_sprite.frames.has_animation(anim_name):
		print("I don't Have the %s Animation" % anim_name)
	
	$animated_sprite.set_animation(anim_name)
	
	return $animated_sprite.frames.has_animation(anim_name)


func try_attack():
	var time_to_attack = time > self.next_attack_time
	
	if time_to_attack and !self.is_attacking:
		set_animation("attack")
	else:
		set_animation("idle")


func attack():
	# Still a bit raw, but at some point, attacking will be more complex.
	# Instead of hardcoding stuff, there will be some stats taking care of it.
	
	var enemies = $attack_area.get_enemies()
	var closest_enemy = get_closest_enemy(enemies)
	
	if closest_enemy:
		closest_enemy.take_damage(self)
	
	is_attacking = false
	next_attack_time = time + stats.attack_cooldown


func take_damage(_enemy):
	self.health -= _enemy.get_damage()
	
	if self.health <= 0:
		self.health = 0
		set_animation("death")
		
		# Fallback, just die, forget about the death animation...
		var has_death_animation = $animated_sprite.frames.has_animation("death")
		if !has_death_animation:
			print("I am dying...")
			queue_free()
	
	

func move(delta):
	set_animation("walk")
	
	var x_velocity = self.get_speed() * direction * delta
	var velocity : Vector2 = Vector2(x_velocity, 0)
	translate(velocity)


func get_closest_enemy(enemies):
	if enemies.empty():
		return
	
	var closest_enemy
	
	for enemy in enemies:
		if !closest_enemy:
			closest_enemy = enemy
			continue
		
		var current_diff = enemy.position.x - self.position.x
		var closest_diff = closest_enemy.position.x - self.position.x
		
		if abs(current_diff) < abs(closest_diff):
			closest_enemy = enemy
		
	return closest_enemy


func get_damage():
	# At least for now...
	return self.stats.damage


func get_health():
	return self.health


func get_max_health():
	return self.stats.health


func get_speed():
	return self.stats.movement_speed

