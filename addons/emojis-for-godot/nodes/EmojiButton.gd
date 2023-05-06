tool
extends Button
class_name EmojiButton, "res://addons/emojis-for-godot/icons/EmojiButton.svg"

export var emoji_name := "sunglasses" setget _set_emoji
export(String, "16", "36", "72") var emoji_size := "36" setget _set_emoji_size

var emojis = Emojis.new()

func _init():
	_set_emoji(emoji_name)
	_set_emoji_size(emoji_size)

func _set_emoji(value: String) -> void:
	emoji_name = value
	var emoji = emojis.get_path_to_emoji(value, int(emoji_size))
	if emoji != "":
		icon = load(emoji) as Texture

func _set_emoji_size(value: String) -> void:
	emoji_size = value
	_set_emoji(emoji_name)



