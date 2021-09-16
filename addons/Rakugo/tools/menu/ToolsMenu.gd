tool
extends MenuButton

var plugin:EditorPlugin

func _ready() -> void:
	var docs_icon := get_icon("Help", "EditorIcons")
	get_popup().set_item_icon(2, docs_icon)

func connect_to_plugin() -> void:
	# "res://addons/Rakugo/tools/RakugoTools.gd"
	get_popup().connect("id_pressed", plugin.rakugo_tools, "_on_menu")

func add_item(label:String, icon:Texture, control:Control, function:String, arg=null) -> void:
	var popup = get_popup()
	popup.add_icon_item(icon, label)
	popup.connect("id_pressed", self, "_on_id_pressed", [control, function, arg])

func _on_id_pressed(id:int, control:Control, function:String, arg=null) -> void:
	var f = funcref(control, function)
	f.call_func(arg)
