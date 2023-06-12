tool
extends Label
class_name MaterialIcon, "res://addons/material-design-icons/nodes/MaterialIcon.svg"

export var icon_name := "image-outline" setget _set_icon_name
export (String, "16", "24", "32", "48", "64", "72", "96", "128") var icon_size := "16" setget _set_icon_size

var font := DynamicFont.new()
var MaterialIcons = preload("../icons/icons.gd").new()
const font_path := "addons/material-design-icons/fonts/%s.tres"

var disabled := false
var _global_theme : Theme

func _init():
	font = load(font_path % icon_size)
	set("custom_fonts/font", font)
	text = MaterialIcons.get_icon_char(icon_name)

func is_button() -> bool:
	# using this because: 
	# 'get_parent() is BaseButton' doesn't work 
	var _class := get_parent().get_class()
	var is_button := "Button" in _class
	var is_check_box := "CheckBox" == _class
	return is_button || is_check_box

func _get_toggle_mode() -> bool:
	if is_button():
		return get_parent().toggle_mode

	return false

func _ready():
	if Engine.editor_hint:
		return

	if is_button():
		var button = get_parent()
		button.connect("toggled", self, "_on_toggled")
		button.connect("pressed", self, "_on_button_down")
		button.connect("button_down", self, "_on_button_down")
		button.connect("button_up", self, "_on_button_up")
		button.connect("mouse_entered", self, "_on_hover", [true])
		button.connect("mouse_exited", self, "_on_hover", [false])

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
	
func _get_color(property:String) -> Color:
	return _get_global_theme().get("Button/colors/" + property)

func _get_idle_color() -> Color:
	return _get_color("font_color")

func _set_font_color(value: Color):
	set("custom_colors/font_color", value)

func _on_button_down():
	if !_get_toggle_mode():
		_on_toggled(true)

func _on_button_up():
	if !_get_toggle_mode():
		_on_toggled(false)


func _set_button(pressed: bool, color_property: String):
	var color := _get_idle_color() 
	
	if pressed:
		color = _get_color(color_property)
	
	_set_font_color(color)

func _on_toggled(pressed: bool):
	_set_button(pressed, "font_color_pressed")

func _on_hover(hovered: bool):
	if !_get_toggle_mode():
		_set_button(hovered, "font_color_hover")
	
func _process(_delta):
	if !is_button():
		return

	if disabled != get_parent().disabled:
		disabled = get_parent().disabled
	
		var color := _get_idle_color()
	
		if disabled:
			color = _get_color("font_color_disabled")
		
		_set_font_color(color)

func _get_global_theme() -> Theme:
	if _global_theme != null:
		return _global_theme
	
	var _node = self
	while _global_theme == null:
		_node = _node.get_parent()
		_global_theme = _node.theme
	
	# print("fund theme: ", _global_theme)
	return _global_theme
