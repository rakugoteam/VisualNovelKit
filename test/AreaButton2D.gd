extends Area2D
class_name AreaButton2D, "res://addons/Rakugo/icons/button_2d.svg"

export var theme: Resource
export var hover_color := Color.yellowgreen
export var highlight_color: Color = modulate
export var disabled_color := Color.gray 
export var disabled : bool setget _set_disabled, _get_disabled

var _disabled := false

var idle_color: Color = modulate
var is_mouse_in := false

func _ready():
	if theme and theme is RakugoTheme:
		theme = theme as RakugoTheme
		hover_color = theme.hover_node_color
		highlight_color = theme.focus_node_color
		idle_color = theme.idle_node_color
		disabled_color = theme.disable_node_color

	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _set_disabled(value:bool) -> void:
	_disabled = value
	modulate = idle_color

	if _disabled:
		modulate = disabled_color
	
func _get_disabled() -> bool:
	return _disabled

func _on_body_entered(body):
	if _disabled:
		return

	if body.name == "MouseBody2D":
		modulate = hover_color
		is_mouse_in = true
		emit_signal("mouse_entered")

func _on_body_exited(body):
	if _disabled:
		return

	if body.name == "MouseBody2D":
		modulate = idle_color
		is_mouse_in = false
		emit_signal("mouse_exited")


#todo pressed and highlight support
