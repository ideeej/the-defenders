extends Panel

const CHARACTER_SELECTOR_TEMPLATE_PATH : String = "res://template_scenes/character_selector.tscn"
const CHARACTERS_RESOURCE_PATH : String = "res://resources/characters/"

var available_characters : int = 0

var character_files : Array = []
var character_resources : Array = []

var selected_character : Resource

signal character_selected

func _ready():
	character_files = dir_contents(CHARACTERS_RESOURCE_PATH)
	
	for character_file in character_files:
		var char_res = load(CHARACTERS_RESOURCE_PATH + character_file)
		character_resources.append(char_res)
	
	available_characters = character_resources.size()
	
	
	var template : PackedScene = load(CHARACTER_SELECTOR_TEMPLATE_PATH)
	
	var characters : Array = []
	for i in range(available_characters):
		var character_selector = template.instance()
		
		
		var character_resource = character_resources[i]
		character_selector.setup(character_resource)
		character_selector.connect("button_down", self, "character_selected", [character_resource])
		
		characters.append(character_selector)
	
	
	for character in characters:
		$ScrollContainer/VBoxContainer.add_child(character)


func character_selected(resource):
	selected_character = resource
	emit_signal("character_selected")
	

func dir_contents(path):
	var files : Array = []
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
		return files
	else:
		print("An error occurred when trying to access the path.")
