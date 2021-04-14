tool
extends RichTextLabel
class_name RakugoTextLabel, "res://addons/Rakugo/icons/rakugo_text_label.svg"

var text_parser : RakugoTextParser
export(String, MULTILINE) var rakugo_text:String setget _set_rakugo_text, _get_rakugo_text

var _rakugo_text := ""
var _markup := "game_setting"

func _ready() -> void:
	bbcode_enabled = true
	text_parser = _get_text_parser()

func _get_text_parser() -> RakugoTextParser:
	if Engine.editor_hint:
		return RakugoTextParser.new()
	
	else:
		return Rakugo.TextParser as RakugoTextParser

func _set_rakugo_text(value:String) -> void:
	_rakugo_text = value
	bbcode_text = text_parser.parse(value, _markup, Engine.editor_hint)
	
func _get_rakugo_text() -> String:
	return _rakugo_text



