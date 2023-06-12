tool
extends VBoxContainer

export var grid_path : NodePath
export var grid_bound := 0.9
export var button_x := 36

onready var grid := get_node(grid_path)
var file := File.new()
var emojis = preload("../emojis/emojis.gd").new()

signal emoji_selected(emoji_name)

func _ready():
	for ch in grid.get_children():
		var b := ch as Button
		b.connect("pressed", self, "on_emoji_clicked", [b])

func on_emoji_clicked(button: Button):
	emit_signal('emoji_selected', button.name)
	OS.clipboard = button.name

func _on_resized():
	if grid == null:
		grid = get_node(grid_path)
	grid.columns = int((rect_size.x / button_x)*grid_bound)

func _on_about_to_show():
	_on_resized()
