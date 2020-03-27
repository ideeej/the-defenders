extends Control

var title : Label
var animated_sprite : AnimatedSprite
var upgrade_button : Button

var attack_button : Button
var walk_button : Button
var idle_button : Button
var hurt_button : Button

var stats_title : Label
var health : Label
var damage : Label
var vision_range : Label
var range_radius : Label
var recharge_time : Label
var attack_cooldown : Label

export(Resource) var selected_character : Resource

var previous_animation : String = ""

func _ready():
	title = $Title
	animated_sprite = $CenterContainer/Pivot/AnimatedSprite
	
	attack_button = $AttackButton
	walk_button = $WalkButton
	idle_button = $IdleButton
	hurt_button = $HurtButton
	
	health = $Stats/health
	damage = $Stats/damage
	vision_range = $Stats/range
	range_radius = $Stats/range_radius
	recharge_time = $Stats/recharge_time
	attack_cooldown = $Stats/attack_cooldown
	
	attack_button.connect("pressed", self, "trigger_animation", ["attack"])
	walk_button.connect("pressed", self, "trigger_animation", ["walk"])
	idle_button.connect("pressed", self, "trigger_animation", ["idle"])
	hurt_button.connect("pressed", self, "trigger_animation", ["hurt"])
	
	if selected_character:
		update_character_data(selected_character)


func update_character_data(resource):
	title.text = resource.name
	
	animated_sprite.frames = resource.animation_frames
	animated_sprite.animation = "idle"
	animated_sprite.playing = true
	
	health.text = "health: " + String(resource.stats.health)
	damage.text = "damage: " + String(resource.stats.damage)
	vision_range.text = "range: " + String(resource.stats.vision_range)
	range_radius.text = "range radius: " + String(resource.stats.attack_extent)
	recharge_time.text = "recharge time: " + String(resource.stats.spawn_cooldown)
	attack_cooldown.text = "attack cooldown: " + String(resource.stats.attack_cooldown)
	
	health.hint_tooltip = String(resource.stats.health)
	damage.hint_tooltip = String(resource.stats.damage)
	vision_range.hint_tooltip = String(resource.stats.vision_range)
	range_radius.hint_tooltip = String(resource.stats.attack_extent)
	recharge_time.hint_tooltip = String(resource.stats.spawn_cooldown)
	attack_cooldown.hint_tooltip = String(resource.stats.attack_cooldown)


func trigger_animation(animation):
	animated_sprite.animation = animation


