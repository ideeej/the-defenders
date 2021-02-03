extends KinematicBody2D


export(Resource) var character_data : Resource

var stats : Resource

# Actual character health
var health : float

var is_attacking: bool = false
var direction : int

var state : String


var time : float = 0
var next_attack_time : float = 0

func _ready():
	stats = character_data.stats
	health = stats.health
	
	
	if character_data.is_enemy:
		direction = -1
	else:
		direction = 1
	
	$animated_sprites.connect("animation_finished", self, "_on_animation_finished")
	$animated_sprites.initialize(character_data)
	
	
	var collider_layers : Dictionary = layer_manager.calculate_layers(character_data)
	
	set_collision_layer(collider_layers.own)
	set_collision_mask(collider_layers.enemy)
	
	
	$collider.setup_extents($animated_sprites.width, $animated_sprites.height)
	
	
	$vision_area.initialize(self.stats, collider_layers)
	$attack_area.initialize(self.stats, collider_layers)


func _process(delta):
	pass
	


func _physics_process(delta):
	if !$vision_area.has_enemies():
		move(delta)
	else:
		try_attack()
	
	state = $animated_sprites.animation

	time += delta


func _on_animation_finished():
	if $animated_sprites.animation == "attack":
		print("ATTACKED")
		attack()
	

func set_animation(anim_name):
	$animated_sprites.set_animation(anim_name)


func try_attack():
	if time > next_attack_time:
		if !is_attacking:
			set_animation("attack")
			print("ATTACKING....")
	else:
		set_animation("idle")

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
	set_animation("walk")
	
	var velocity : Vector2 = Vector2(
		stats.movement_speed * direction * delta,
		0
	)
	translate(velocity)

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


func get_health():
	return self.health

func get_max_health():
	return self.stats.health


