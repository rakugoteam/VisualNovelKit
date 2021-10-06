extends Polygon2D
class_name Button2D, "res://addons/adventure/icons/Region2D.svg"

export var use_global_theme := false
export var theme: Theme
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
var was_mouse_in := false

signal mouse_entered
signal mouse_exited
signal pressed

func _ready() -> void:
	# if use_global_theme:
	# 	theme = load(Settings.get(SettingsList.theme))

	if theme:
		idle_color = _get_color("font_color")
		hover_color = _get_color("font_color_hover")
		highlight_color = _get_color("font_color_hover")
		pressed_color = _get_color("font_color_pressed")
		disabled_color = _get_color("font_color_disabled")

func _get_color(property:String) -> Color:
	return theme.get("Button/colors/" + property)

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

func _process(delta):
	if not _disabled:
		if not _pressed:
			var mouse_position = get_local_mouse_position()
			is_mouse_in = Geometry.is_point_in_polygon(mouse_position, polygon)
			
			if is_mouse_in:
				emit_signal("mouse_entered")
				was_mouse_in = true
				modulate = hover_color

			elif was_mouse_in:
				emit_signal("mouse_exited")
				was_mouse_in = false
				modulate = idle_color

func _input(event:InputEvent) -> void:
	if is_mouse_in:
		if not _pressed:
			if event is InputEventMouseButton:
				var button = event as InputEventMouseButton
				if button.button_index == BUTTON_LEFT:
					_set_pressed(true)
					emit_signal("pressed")
				else:
					pressed = false
	
	if Input.is_action_just_pressed("highlight"):
		modulate = highlight_color

	else:
		modulate = idle_color
