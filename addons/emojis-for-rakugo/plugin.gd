tool
extends RakugoPlugin

var emoji_finder : WindowDialog
var menu_item := ["Emoji Finder", "popup_centered", Vector2(450, 400)]

func _enter_tree():
	var emojis = preload("emojis/emojis.gd").new()
	var button_icon = emojis.get_path_to_emoji("black_square_button", 16)
	var icon_icon = emojis.get_path_to_emoji("sunglasses", 16)
	add_type("EmojiButton", "Button", "nodes/EmojiButton.gd", button_icon)
	add_type("EmojiIcon", "TextureRect", "nodes/EmojiIcon.gd", icon_icon)
	var emoji_finder := "emojis_panel/EmojiPanel.tscn"
	add_control(CONTAINER_TOOLBAR, emoji_finder)
	add_menu_item("Emoji Finder", emoji_finder, "popup_centered", Vector2(450, 400))

