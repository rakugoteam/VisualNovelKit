extends Button

export var char_size := Vector2(10, 20)

var rakugo_text setget _set_rakugo_text, _get_rakugo_text

var _rakugo_text := ""

signal choice_button_pressed(button)

func _on_pressed():
	self.emit_signal("choice_button_pressed", self)

func _set_rakugo_text(value:="") -> void:
	_rakugo_text = value
	$RakugoTextLabel.rakugo_text = "[center]"
	$RakugoTextLabel.rakugo_text += value
	$RakugoTextLabel.rakugo_text += "[/center]"
	$RakugoTextLabel.resize_to_text(char_size, "y")
	self.rect_min_size += $RakugoTextLabel.rect_size

func _get_rakugo_text() -> String:
	return _rakugo_text
