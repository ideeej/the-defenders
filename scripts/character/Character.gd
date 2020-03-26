extends KinematicBody2D

export(Resource) var template : Resource

var stats : Resource
var health : float
var direction : int

var is_attacking : bool

var state : String


var time : float = 0
var next_attack_time : float = 0


func _ready():
	var layer_manager : Node = get_node("/root/layer_manager")
	
	stats = template.stats
	health = stats.health
	
	if template.is_enemy:
		direction = 1
	else:
		direction = -1
	
	$animated_sprites.connect("animation_finished", self, "on_animation_finished")
	
	$animated_sprites.setup_animation_direction(template)
	$animated_sprites.setup_animation_frames(template.animation_frames)
	$animated_sprites.set_playing(true)
	$animated_sprites.animation = "idle"
	
	
	var sprite_extents : Vector2 = Vector2(
		$animated_sprites.get_frame_width(),
		$animated_sprites.get_frame_height()
	)
	
	var collider_layers : Dictionary = layer_manager.calculate_layers(template)
	
	set_collision_layer(collider_layers.own)
	set_collision_mask(collider_layers.enemy)
	
	$collider.setup_extents(sprite_extents)
	
	$vision_area.setup_extents(sprite_extents + Vector2(stats.vision_range, 0))
	$vision_area.offset(Vector2(sprite_extents.x/2, 0) + Vector2(stats.vision_range, 0))
	$vision_area.setup_layers(collider_layers.own, collider_layers.enemy)
	
	$attack_area.setup_extents(Vector2(stats.attack_extent, sprite_extents.y))
	$attack_area.offset(Vector2(sprite_extents.x/2, 0) + Vector2(stats.vision_range*2, 0) + Vector2(stats.attack_extent, 0))
	$attack_area.setup_layers(collider_layers.own, collider_layers.enemy)
	




func _physics_process(delta):
	if !$vision_area.has_enemies():
		move(delta)
	else:
		try_attack()
	
	update_states()

	time += delta


func on_animation_finished():
	if $animated_sprites.animation == "attack":
		attack()


func update_states():
	state = $animated_sprites.animation


func get_closest_enemy(enemies):
	if enemies.empty():
		return
	
	var closest_enemy
	
	for enemy in enemies:
		if !closest_enemy:
			closest_enemy = enemy
			continue
		
		if abs(enemy.position.x - position.x) < abs(closest_enemy.position.x - position.x):
			closest_enemy = enemy
		
	return closest_enemy


func trigger_attack():
	$animated_sprites.set_animation("attack")


func trigger_idle():
	$animated_sprites.set_animation("idle")


func trigger_walk():
	$animated_sprites.set_animation("walk")


func try_attack():
	if time > next_attack_time:
		if !is_attacking:
			trigger_attack()
	else:
		trigger_idle()


func attack():
	var enemies = $attack_area.get_enemies()
	var closest_enemy = get_closest_enemy(enemies)
	
	if closest_enemy:
		closest_enemy.take_damage(self)
	
	is_attacking = false
	next_attack_time = time + stats.attack_cooldown


func take_damage(_enemy):
	health -= _enemy.stats.damage
	
	if health <= 0:
		health = 0
		queue_free()
	
	

func move(delta):
	trigger_walk()
	
	var velocity : Vector2 = Vector2(
		stats.movement_speed * direction * delta,
		0
	)
	translate(velocity)


func get_max_health():
		return stats.health


func get_health():
		return health









