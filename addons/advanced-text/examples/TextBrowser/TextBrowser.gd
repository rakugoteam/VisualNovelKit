extends Panel

export(String, FILE, "*.md, *.rpy, *.txt") var home_text_file := ""
export var tab_button_scene : PackedScene
export var text_view_scene : PackedScene

export (NodePath) onready var tabs = get_node(tabs) as TabContainer
export (NodePath) onready var tabs_box = get_node(tabs_box) as VBoxContainer

var current_text_view : AdvancedTextLabel
var tabs_group := ButtonGroup.new()
var tabs_dir := {}
var paths_dir := {}

func _ready():
	_open_file(home_text_file)

func _open_file(file:String) -> void:
	var new_text_view = text_view_scene.instance()
	new_text_view.markup_text_file = file
	new_text_view.connect("meta_clicked", self, "_on_meta_clicked")
	tabs.add_child(new_text_view)
	tabs.current_tab = tabs.get_tab_count() - 1

	var new_tab_button = tab_button_scene.instance()
	var file_name = file.get_file()
	var button : Button = new_tab_button.get_node("FileButton")
	button.text = file_name
	button.toggle_mode = true
	button.pressed = true
	button.group = tabs_group
	button.connect("pressed", self, "_on_tab_pressed", [new_tab_button])

	var close_button : Button = new_tab_button.get_node("CloseButton")
	close_button.connect("pressed", self, "_on_tab_closed", [new_tab_button])
	tabs_box.add_child(new_tab_button)

	tabs_dir[new_tab_button] = new_text_view
	paths_dir[file] = new_tab_button
	current_text_view = new_text_view

func _on_meta_clicked(meta:String):
	if meta in paths_dir.keys():
		var tab_button = paths_dir[meta]
		tab_button.emit_signal("pressed", [tab_button])
		return

	if meta.begins_with("res://"):
		_open_file(meta)

func _on_tab_closed(caller:Node):
	var text_view = tabs_dir[caller]
	tabs.remove_child(text_view)
	tabs_box.remove_child(caller)

func _on_tab_pressed(caller:Node):
	current_text_view.hide()
	current_text_view = tabs_dir[caller]
	current_text_view.show()
