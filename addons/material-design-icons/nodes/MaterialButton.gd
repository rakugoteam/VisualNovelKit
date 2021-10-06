tool
extends Button

export var icon_name := "image-outline" setget _set_icon_name
export var icon_size := 24 setget _set_icon_size

var font := DynamicFont.new()
var MaterialIcons = preload("../icons/icons.gd").new()
const font_file := preload("../fonts/material_design_icons.ttf")

func _init():
	clip_text = false
	font.font_data = font_file
	font.size = icon_size
	font.use_filter = true
	set("custom_fonts/font", font)
	text = MaterialIcons.get_icon_char(icon_name)

func _set_icon_name(value: String):
	icon_name = value
	
	if get("custom_fonts/font") != font:
		_init()
	else:
		text = MaterialIcons.get_icon_char(icon_name)

func _set_icon_size(value: int):
	icon_size = value
	
	if get("custom_fonts/font") != font:
		_init()
	else:
		font.size = icon_size

	set("custom_fonts/font", font)