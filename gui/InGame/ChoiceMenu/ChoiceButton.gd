tool
extends RakugoTextLabel
class_name RakugoButton

export var min_size := Vector2(10, 20)
export var char_size := Vector2(5, 10)
export var disabled := false

var rt: RakugoTheme 
var _disabled := false

signal choice_button_pressed(button)

func _ready():
	._ready()
	rt = theme as RakugoTheme
	_set_disabled(_disabled)
	meta_underlined = false;
	scroll_active = false;

func _set_disabled(value:bool):
	_disabled = value
	if _disabled:
		modulate = rt.disable_node_color
	else:
		modulate = rt.idle_node_color

func _get_disabled() -> bool:
	return _disabled

func _on_meta_clicked(meta):
	modulate = rt.pressed_node_color
	self.emit_signal("choice_button_pressed", self)

func _on_meta_hover_ended(meta):
	modulate = rt.hover_node_color

func _on_meta_hover_started(meta):
	modulate = rt.idle_node_color

func _set_rakugo_text(value:String):
	._set_rakugo_text(value)
	resize_to_text(min_size, char_size)
	push_meta("")
	push_align(ALIGN_CENTER)
