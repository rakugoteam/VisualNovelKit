tool
extends EditorPlugin
class_name RakugoPlugin

var _file := File.new()
var _cfg := ConfigFile.new()

func local(path:String):
	if path.begins_with("res://"):
		return load(path)
		
	return load(get_path_here() + path)
	
func get_path_here() -> String:
	var path_here : String = get_script().resource_path
	return path_here.replace("plugin.gd", "")
	
func load_cfg():
	var cfg_path := "res://rakugo.cfg"
	if _cfg == null:
		_cfg.new()
		if _file.file_exists(cfg_path):
			_cfg.load(cfg_path)
	return _cfg

func _get_section() -> String:
	return "plugins/" + _get_plugin_name()

func _get_plugin_data(key:String, def_value = null):
	_cfg = load_cfg() 
	return _cfg.get_value(_get_section(), key, def_value)

func _save_plugin_data(key:String, new_value):
	_cfg = load_cfg() 
	
	var plugins : Array = _cfg.get_value("project", "plugins", [])
	if ! (_get_plugin_name() in plugins):
		plugins.append(_get_plugin_name())
		_cfg.set_value("project", "plugins", plugins)
		
	_cfg.set_value(_get_section(), key, new_value)
	_cfg.save("res://rakugo.cfg")

func add_type(type_name:String, base_class:String, script_path:String, icon_path:String):
	add_custom_type(type_name, base_class, local(script_path), local(icon_path))
	var types: Array = _get_plugin_data("types", [])
	types.append(type_name) 
	_save_plugin_data("types", types)

func _get_plugin_name() -> String:
	var pcfg := ConfigFile.new()
	var cfg_path := get_path_here() + "/plugin.cfg"
	if _file.file_exists(cfg_path):
		pcfg.load(cfg_path)
		return pcfg.get_value("plugin", "name")
	return ""

func add_control(container:int, scene_path:String):
	var controls : Dictionary = _get_plugin_data("controls", {})
	controls[scene_path] = container
	_save_plugin_data("controls", controls)

func add_menu_item(label:String, scene_path:String,  method:String, arg = null):
	var items : Dictionary = _get_plugin_data("menu", {})
	items[label] = {"scene":scene_path, "method":method, "arg":arg}
	_save_plugin_data("menu", items)
	
func _exit_tree():
	var _cfg : ConfigFile = load_cfg()
	var types : Array = _get_plugin_data("types", [])
	if types.size() > 0:
		for t in types:
			remove_custom_type(t)
	
	var plugins : Array = _cfg.get_value("project", "plugins", [])
	if _get_plugin_name() in plugins:
		plugins.erase(_get_plugin_name())
		_cfg.set_value("project", "plugins", plugins)
	
	_cfg.erase_section(_get_section())
	
