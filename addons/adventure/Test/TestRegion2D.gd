extends "res://addons/adventure/nodes/Region2D.gd"

export var hover_color := Color.blue
export var highlight_color := Color.white
export var disabled_color := Color.gray

func _on_highlighted(is_highlighted):
	if is_highlighted:
		modulate = highlight_color
	else:
		modulate = Color.white

func _on_mouse_entered():
	modulate = hover_color

func _on_mouse_exited():
	modulate = Color.white

func _on_pressed():
	print("pressed")

func _on_disabled_changed(is_disabled):
	if is_disabled:
		modulate = disabled_color
	else:
		modulate = Color.white
