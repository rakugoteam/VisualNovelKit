tool
extends TextureRect

export var emoji_name := "sunglasses" setget _set_emoji
export(String, "16", "36", "72") var emoji_size := "36" setget _set_emoji_size

var emojis = preload("../emojis/emojis.gd").new()

func _set_emoji(value: String) -> void:
	emoji_name = value
	var emoji = emojis.get_path_to_emoji(value, int(emoji_size))
	if emoji != "":
		texture = load(emoji) as Texture

func _set_emoji_size(value: String) -> void:
	emoji_size = value
	_set_emoji(emoji_name)
