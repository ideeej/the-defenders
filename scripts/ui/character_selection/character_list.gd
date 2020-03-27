extends Control

const CHARACTERS_RESOURCE_PATH : String = "res://resources/characters/"
const ITEM_TEMPLATE_SCENE_PATH : String = "res://template_scenes/character_list_item.tscn"

var characters : Array 
var selected_character : Resource

signal character_selected

onready var error_popup : Popup = $Error
onready var search_bar : LineEdit = $Panel/LineEdit
onready var characters_list : VBoxContainer = $Panel/ScrollContainer/VBoxContainer


func _ready():
	var character_resources = fetch_character_resources()
	var available_characters = character_resources.size()
	var template : PackedScene = load(ITEM_TEMPLATE_SCENE_PATH)
	
	instantiate_items(template, character_resources, available_characters)
	
	search_bar.connect("text_entered", self, "handle_search")
	search_bar.connect("text_changed", self, "handle_search")
	search_bar.connect("text_change_rejected", self, "search_error")


func handle_search(search):
	var most_similar : float = -1
	var guess : Resource = null
	
	for character in characters:
		var similarity = search.similarity(character.name)
		
		if similarity > most_similar:
			most_similar = similarity
			guess = character
	
	if guess:
		emit_signal("character_selected", guess)
	
	if !search.empty():
		filter_characters(guess)
	else:
		show_all_characters()


func search_error(e):
	error_popup.popup_centered()
	

func character_selected(resource):
	selected_character = resource
	emit_signal("character_selected", resource)


func filter_characters(guess):
	var children : Array = characters_list.get_children()
	
	for child in children:
		if child.resource.name == guess.name:
			child.visible = true
		else:
			child.visible = false


func show_all_characters():
	var children : Array = characters_list.get_children()
	
	for child in children:
		child.visible = true


func fetch_character_resources():
	var character_resources : Array = []
	var character_files : Array = dir_contents(CHARACTERS_RESOURCE_PATH)
	
	for character_file in character_files:
		var character_resource : Resource = load(CHARACTERS_RESOURCE_PATH + character_file)
		character_resources.append(character_resource)
	
	return character_resources


func instantiate_items(template, resources, amount):
	for i in range(amount):
		var character_list_item = template.instance()
		var resource = resources[i]
		
		character_list_item.setup(resource)
		character_list_item.connect("button_down", self, "character_selected", [resource])
		
		characters.append(resource)
		characters_list.add_child(character_list_item)


func dir_contents(path):
	#Copy paste from stack overflow
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
