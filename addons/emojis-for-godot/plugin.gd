tool
extends EditorPlugin

var emoji_finder : WindowDialog
var menu_item := ["Emoji Finder", "popup_centered", Vector2(450, 400)]

func _enter_tree():
  var emojis = preload("emojis/emojis.gd").new()
  var button_icon = load(emojis.get_path_to_emoji("black_square_button", 16))
  var icon_icon = load(emojis.get_path_to_emoji("sunglasses", 16))
  add_custom_type("EmojiButton", "Button", preload("nodes/EmojiButton.gd"), button_icon)
  add_custom_type("EmojiIcon", "TextureRect", preload("nodes/EmojiIcon.gd"), icon_icon)
  emoji_finder = preload("EmojiPanel/EmojiPanel.tscn").instance()
  add_control_to_container(CONTAINER_TOOLBAR, emoji_finder)
  add_tool_menu_item(menu_item[0], emoji_finder, menu_item[1], menu_item[2])
  
func _exit_tree():
  remove_custom_type("EmojiButton")
  remove_custom_type("EmojiIcon")
  remove_control_from_container(CONTAINER_TOOLBAR, emoji_finder)
