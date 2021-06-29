extends Area2D
class_name AreaButton2D

export var theme: Resource
export var hover_color := Color.yellowgreen
export var highlight_color: Color = modulate
export var disabled_color: Color = modulate

var idle_color: Color = modulate
var is_mouse_in := false

func _ready():
	if theme and theme is RakugoTheme:
		theme = theme as RakugoTheme
		hover_color = theme.hover_node_color
		highlight_color = theme.focus_node_color
		idle_color = theme.idle_node_color

	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "MouseBody2D":
		modulate = hover_color
		is_mouse_in = true
		emit_signal("mouse_entered")

func _on_body_exited(body):
	if body.name == "MouseBody2D":
		modulate = idle_color
		is_mouse_in = false
		emit_signal("mouse_exited")


#todo disabled, pressed and highlight support
