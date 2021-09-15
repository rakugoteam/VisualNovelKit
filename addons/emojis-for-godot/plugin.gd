tool
extends EditorPlugin

var rakugo := false
var emoji_finder = preload("emojis_panel/EmojiPanel.gd")
var emojis = preload("emojis/emojis.gd").new()

func _enter_tree():
  var button_icon = load(emojis.et_path_to_emoji("black_square_button", 16))
  var icon_icon = load(emojis.et_path_to_emoji("sunglasses", 16))
  add_custom_type("EmojiButton", "Button", preload("nodes/EmojiButton.gd"), button_icon)
  add_custom_type("EmojiIcon", "TextureRect", preload("nodes/EmojiIcon.gd"), icon_icon)
  # rakugo = OS.
  
  if !rakugo:
    add_tool_menu_item("Emoji Finder", emoji_finder, "popup_centered")

func _exit_tree():
  remove_custom_type("EmojiButton")
  remove_custom_type("EmojiIcon")

  if !rakugo:
    remove_tool_menu_item("Emoji Finder")