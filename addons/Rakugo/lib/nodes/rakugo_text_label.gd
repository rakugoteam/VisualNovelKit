tool
extends RichTextLabel
class_name RakugoTextLabel, "res://addons/Rakugo/icons/rakugo_text_label.svg"

var text_parser : RakugoTextParser setget , _get_text_parser
export(String, MULTILINE) var rakugo_text:String setget _set_rakugo_text, _get_rakugo_text
export(String, "game_setting", "renpy", "bbcode", "markdown" ,"markdown_simple") var markup := "project_setting"

var _rakugo_text := ""
var _text_parser : RakugoTextParser

func _ready() -> void:
	bbcode_enabled = true

func _get_text_parser() -> RakugoTextParser:
	if !_text_parser:
		if Engine.editor_hint:
			_text_parser = RakugoTextParser.new()
		
		else:
			_text_parser = Rakugo.TextParser as RakugoTextParser
	
	return _text_parser
	
func _set_rakugo_text(value:String) -> void:
	if Rakugo.started or Engine.editor_hint:
		_rakugo_text = value
		bbcode_text = _get_text_parser().parse(value, _get_markup(), Engine.editor_hint)
	
func _get_rakugo_text() -> String:
	return _rakugo_text

func _get_markup() -> String:
	if markup == "project_setting":
		return ""
	
	return markup
