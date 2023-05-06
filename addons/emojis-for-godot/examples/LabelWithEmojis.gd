extends RichTextLabel

var emojis = load("res://addons/emojis-for-godot/emojis/emojis.gd").new()
export var text_with_emojis := "some emoji :sunglasses:"
 
func _ready():
	bbcode_enabled = true
	bbcode_text = emojis.parse_emojis(text_with_emojis)
