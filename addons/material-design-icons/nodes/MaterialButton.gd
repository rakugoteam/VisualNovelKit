tool
extends Button
class_name MaterialButton, "res://addons/material-design-icons/nodes/MaterialButton.svg"

export var icon_name := "image-outline" setget _set_icon_name
export (String, "16", "24", "32", "48", "64", "72", "96", "128") var icon_size := "16" setget _set_icon_size

var font := DynamicFont.new()
var MaterialIcons = preload("../icons/icons.gd").new()
const font_path := "addons/material-design-icons/fonts/%s.tres"

func _init():
	clip_text = false
	font = load(font_path % icon_size)
	set("custom_fonts/font", font)
	text = MaterialIcons.get_icon_char(icon_name)

func _set_icon_name(value: String):
	icon_name = value
	
	if get("custom_fonts/font") != font:
		_init()
	else:
		text = MaterialIcons.get_icon_char(icon_name)

func _set_icon_size(value: String):
	icon_size = value
	
	if get("custom_fonts/font") != font:
		_init()
	else:
		font = load(font_path % icon_size)

	set("custom_fonts/font", font)
