tool
extends Node

var json_path = "res://addons/material-design-icons/icons/icons.json"
var icons:Dictionary = {} setget dummy_set

func _init():
	var content = get_file_content(json_path)
	var json_dict = parse_json(content) as Dictionary
	init_icons_dictionaries(json_dict)

func get_file_content(path:String) -> String:
	var file = File.new()
	var error = file.open(path, file.READ)
	var content = ""
	
	if error == OK:
		content = file.get_as_text()
		file.close()

	return content

func init_icons_dictionaries(dict:Dictionary):
	icons = {}
	for icon in dict:
		var hex: String = dict[icon].to_lower()
		var value: int = ("0x"+ hex).hex_to_int()
		icons[icon] = value

func get_icon_code(id:String) -> int:
	if id in icons:
		return icons[id]
		
	push_warning("Icon '%s' not found." % id)
	return 0
func get_icon_char(id:String) -> String:
	return char(get_icon_code(id))


func dummy_set(_value):
	pass