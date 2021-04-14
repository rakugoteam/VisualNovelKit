tool
extends Node

onready var grid := $ScrollContainer/GridContainer
var file := File.new()
var emojis = Emojis.new()

signal emoji_selected(emoji_name, emoji_code)

func _ready():
	for e in emojis.name_to_code_emojis.keys():
		var png = emojis.get_path_to_emoji(emojis.name_to_code_emojis[e], 36)
		if not file.file_exists(png):
			continue
			
		var b := Button.new()
		b.name = e
		b.icon = load(png)
		b.connect("pressed", self, "on_emoji_clicked", [b])
		grid.add_child(b)


func on_emoji_clicked(button: Button):
	var emoji = add_markup(button.name)
	emit_signal('emoji_selected', emoji, emojis.name_to_code_emojis[button.name])
	OS.clipboard = emoji

func add_markup(text:String):
	match ProjectSettings.get(SettingsList.markup):
		"bbcode":
			text = "[:%s:]" % text
		"renpy":
			text = "{:%s:}" % text
		"markdown":
			text = ":%s:" % text
	return text

