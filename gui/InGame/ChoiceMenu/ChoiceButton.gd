extends Button

signal choice_button_pressed(button)
var rakugo_text setget _set_rakugo_text, _get_rakugo_text

var _rakugo_text := ""

func _on_pressed():
	self.emit_signal("choice_button_pressed", self)

func _set_rakugo_text(value:="") -> void:
	_rakugo_text = value
	$RakugoTextLabel.rakugo_text = "[center]"
	$RakugoTextLabel.rakugo_text += value
	$RakugoTextLabel.rakugo_text += "[/center]"
	

func _get_rakugo_text() -> String:
	return _rakugo_text
