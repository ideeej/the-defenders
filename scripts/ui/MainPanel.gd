extends PanelContainer


export(Resource) var character_template

var animations : Dictionary = {
	"Idle": "idle",
	"Walk": "walk",
	"Attack": "attack",
	"Hurt": "hurt"
}

var animated_sprite : AnimatedSprite

var parent : Control
var characters_node : Panel

func _ready():
	parent = get_parent()
	
	# Probably a good idea to store states and stuff on the parent
	# Just for ease of use
	characters_node = parent.get_node("Characters")
	characters_node.connect("character_selected", self, "character_selected")
	
	setup(character_template)
	

func character_selected():
	setup(characters_node.selected_character)

func setup(resource):
	$info_container/name_container/name.text = resource.name
	$info_container/stats_container/health_label/health.text = String(resource.stats.health)
	$info_container/stats_container/damage_label/damage.text = String(resource.stats.damage)
	$info_container/stats_container/range_label/range.text = String(resource.stats.vision_range)
	$info_container/stats_container/range_radius_label/range_radius.text = String(resource.stats.attack_extent)
	
	
	animated_sprite = $character_stage/pivot/character_preview
	
	animated_sprite.frames = resource.animation_frames
	animated_sprite.playing = true
	animated_sprite.animation = animations.Idle


func _process(_delta):
	var selected_animation = $debug_container/animation_options.selected
	var curr_animation =  $debug_container/animation_options.items[selected_animation * 5] # Why fucc
	
	animated_sprite.animation = curr_animation
	
	
	
