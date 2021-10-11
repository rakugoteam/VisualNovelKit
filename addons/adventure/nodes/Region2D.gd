extends Polygon2D

export var disabled : bool setget _set_disabled, _get_disabled
export var pressed : bool setget _set_pressed, _get_pressed

var _pressed := false
var _disabled := false

var is_mouse_in := false
var was_mouse_in := false

signal mouse_entered
signal mouse_exited
signal highlighted(is_highlighted)
signal disabled_changed(is_disabled)
signal pressed


func _set_disabled(value:bool) -> void:
	_disabled = value

func _get_disabled() -> bool:
	emit_signal("disabled_changed", _disabled)
	return _disabled

func _set_pressed(value:bool) -> void:
	_pressed = value
	if _pressed:
		emit_signal("pressed")

func _get_pressed() -> bool:
	return _pressed

func _process(delta):
	if not _disabled:
		var mouse_position = get_local_mouse_position()
		is_mouse_in = Geometry.is_point_in_polygon(mouse_position, polygon)
		
		if is_mouse_in:
			emit_signal("mouse_entered")
			was_mouse_in = true

		elif was_mouse_in:
			emit_signal("mouse_exited")
			was_mouse_in = false

func _input(event:InputEvent) -> void:
	if is_mouse_in:
		if not _disabled:
			if event is InputEventMouseButton:
				var button = event as InputEventMouseButton
				if button.button_index == BUTTON_LEFT:
					_set_pressed(button.is_pressed())
	
	if Input.is_action_just_pressed("highlight"):
		emit_signal("highlighted", true)
	
	if Input.is_action_just_released("highlight"):
		emit_signal("highlighted", false)
