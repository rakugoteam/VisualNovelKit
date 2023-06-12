tool
extends TextEdit
class_name CodeEdit, "res://addons/advanced-text/icons/CodeEdit.svg"

var f : File
var EmojisImport
var emojis_gd

var IconsImport
var icons_gd

signal update

export(String, FILE) var text_file := "" setget _set_text_file
export var highlight_colors := true
export(Array, String, FILE, "*.json") var configs

func _ready() -> void:
	EmojisImport = preload("../emojis_import.gd")
	EmojisImport = EmojisImport.new()

	IconsImport = preload("../material_icons_import.gd")
	IconsImport = IconsImport.new()

	syntax_highlighting = true

	clear_colors()
	_add_keywords_highlighting()
	connect("update", self, "_on_update")
	emit_signal("update")

func _set_text_file(value:String) -> void:
	text_file = value
	emit_signal("update")

func _on_update() -> void:
	if text_file:
		_load_file(text_file)

func _load_file(file_path:String) -> void:
	f = File.new()
	f.open(file_path, File.READ)
	text = f.get_as_text()
	f.close()

func switch_config(json_file:String, id:=0) -> void:
	clear_colors()
	configs[id] = json_file
	_add_keywords_highlighting()

func _add_keywords_highlighting() -> void:
	if configs.size() > 0:
		for json in configs:
			load_json_config(json)
	
	if highlight_colors:
		_highlight_colors()

func _highlight_colors():
	var colors := { 
		"aqua": Color.aqua, 
		"black": Color.black,
		"blue": Color.blue,
		"fuchsia": Color.fuchsia,
		"gray": Color.gray,
		"green": Color.green,
		"lime": Color.lime,
		"maroon": Color.maroon,
		"navy": Color("#7faeff"),
		"purple": Color.purple,
		"red": Color.red,
		"silver": Color.silver,
		"teal": Color.teal,
		"white": Color.white,
		"yellow":	Color.yellow
	}

	for c in colors.keys():
		add_keyword_color(c, colors[c])

func load_json_config(json: String) -> void:
	var content := get_file_content(json)
	var config : Dictionary = parse_json(content)

	for conf in config:
		read_conf_element(config, conf)

func read_conf_element(config:Dictionary, conf):
	var c = config[conf]
	
	match conf:
		"emojis":
			if EmojisImport.is_plugin_enabled():
				load_emojis_if_exists(read_color(c, "color"))
			else:
				EmojisImport.free()

		"icons":
			if IconsImport.is_plugin_enabled():
				load_icons_if_exists(read_color(c, "color"))
			else:
				IconsImport.free()
				
		"class":
			read_class_conf_if_exist(c)
			
		_:
			if c.has("region"):
				read_region_if_exist(c, read_color(c, "color"))

			if c.has("keywords"):
				read_keywords_if_exist(c, read_color(c, "color"))

func read_color(c:Dictionary, color:String) -> Color:
	return Color(c[color].to_lower())

func load_emojis_if_exists(color: Color) -> void:
	if emojis_gd == null:
		emojis_gd = EmojisImport.get_emojis()

	if emojis_gd:
		for e in emojis_gd.emojis.keys():
			add_keyword_color(e, color)

func load_icons_if_exists(color: Color) -> void:
	if icons_gd == null:
		icons_gd = IconsImport.get_icons()

	if icons_gd:
		for e in icons_gd.icons.keys():
			add_keyword_color(e, color)

func read_region_if_exist(c, color:Color): 
	if c.has("region"):
		var r = c["region"]
		add_color_region(r[0], r[1], color)
	
func read_keywords_if_exist(c, color:Color):
	if c.has("keywords"):
		var keywords = c["keywords"]
		for k in keywords:
			add_keyword_color(k, color)

func read_class_conf_if_exist(c):
	var class_color := read_color(c, "class_color")
	var variables_color := read_color(c, "variables_color")
	if c.has("load") and c["load"]:
		for c in ClassDB.get_class_list():
			add_keyword_color(c, class_color)
			for m in ClassDB.class_get_property_list(c):
				for key in m:
					add_keyword_color(key, variables_color)

	if c.has("custom_classes"):
		for _class in c["custom_classes"]:
			add_keyword_color(_class, class_color)

func get_file_content(path:String) -> String:
	var file = File.new()
	var error : int = file.open(path, file.READ)
	var content : = ""
	
	if error == OK:
		content = file.get_as_text()
		file.close()

	return content
