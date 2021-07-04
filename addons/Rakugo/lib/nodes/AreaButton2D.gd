extends Area2D
class_name AreaButton2D, "res://addons/Rakugo/icons/button_2d.svg"

export var use_global_theme := false
export var theme: Resource
export var hover_color := Color.blue
export var highlight_color := Color.white
export var pressed_color := Color.darkblue
export var disabled_color := Color.gray
export var disabled : bool setget _set_disabled, _get_disabled
export var pressed : bool setget _set_pressed, _get_pressed

var _pressed := false
var _disabled := false

var idle_color: Color = modulate
var is_mouse_in := false

signal pressed

func _ready() -> void:
	if use_global_theme:
		theme = Settings.get(SettingsList.theme)

	if theme and theme is RakugoTheme:
		theme = theme as RakugoTheme
		hover_color = theme.hover_node_color
		highlight_color = theme.focus_node_color
		idle_color = theme.idle_node_color
		disabled_color = theme.disable_node_color
		pressed_color = theme.pressed_node_color

	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _set_disabled(value:bool) -> void:
	_disabled = value
	modulate = idle_color

	if _disabled:
		modulate = disabled_color
	
func _get_disabled() -> bool:
	return _disabled

func _set_pressed(value:bool) -> void:
	_pressed = value
	modulate = idle_color

	if _pressed:
		modulate = pressed_color
	
func _get_pressed() -> bool:
	return _pressed

func _on_body_entered(body:PhysicsBody2D) -> void:
	if _disabled:
		return

	if body.name == "MouseBody2D":
		modulate = hover_color
		is_mouse_in = true
		emit_signal("mouse_entered")

func _on_body_exited(body:PhysicsBody2D) -> void:
	if _disabled:
		return

	if body.name == "MouseBody2D":
		modulate = idle_color
		is_mouse_in = false
		emit_signal("mouse_exited")

func _input(event:InputEvent) -> void:
	if is_mouse_in:
		if not _pressed:
			if event is InputEventMouseButton:
				var button = event as InputEventMouseButton
				if button.button_index == BUTTON_LEFT:
					_set_pressed(true)
					emit_signal("pressed")
					print("pressed")
	
	if Input.is_action_just_pressed("highlight"):
		modulate = highlight_color

	if Input.is_action_just_released("highlight"):
		modulate = idle_color
