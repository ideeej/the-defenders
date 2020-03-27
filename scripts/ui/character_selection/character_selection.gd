extends Control


var character_list : Control
var character_stage : Control


func _ready():
	character_list = $Character_List
	character_stage = $Character_Stage
	
	character_list.connect("character_selected", self, "update_selected_character")


func update_selected_character(new_character):
	character_stage.update_character_data(new_character)
