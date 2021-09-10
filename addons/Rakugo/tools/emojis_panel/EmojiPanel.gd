tool
extends VBoxContainer

export var grid_path : NodePath

onready var grid := get_node(grid_path)
var file := File.new()
var emojis = Emojis.new()

signal emoji_selected(emoji_name)

func _ready():
	for ch in grid.get_children():
		var b := ch as Button
		b.connect("pressed", self, "on_emoji_clicked", [b])

func on_emoji_clicked(button: Button):
	var emoji = add_markup(button.name)
	emit_signal('emoji_selected', emoji)
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

