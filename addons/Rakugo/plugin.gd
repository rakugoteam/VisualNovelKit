tool
extends RakugoPlugin

var tools_menu : MenuButton
var file := File.new()
var rcfg := ConfigFile.new()
var controls_dir := {}
var types := []
var menu_methods := []

var default_property_list = SettingsList.new().default_property_list

func _enter_tree():

	# load and set default settings
	for property_key in default_property_list.keys():
		var property_value = default_property_list[property_key]
		ProjectTools.set_setting(property_key, property_value[0], property_value[1])
	
	ProjectSettings.set_order("rakugo/game/info/version", 1)
	
	# init rakugo tools
	var sls_editor = "tools/scene_links/SceneLinksEditor.tscn"
	add_control(CONTAINER_TOOLBAR, sls_editor)
	add_menu_item("Scene Links Editor", sls_editor, "popup_centered", Vector2(450, 400))

	var about = "tools/about/AboutDialog.tscn"
	add_control(CONTAINER_TOOLBAR, about)
	add_menu_item("About", about, "popup_centered", Vector2(450, 400))

	# load plugins
	var plugins : Array = ProjectSettings.get_setting("editor_plugins/enabled")
	tools_menu = MenuButton.new()
	tools_menu.text = "Rakugo"
	var popup = tools_menu.get_popup()
	
	for p in plugins:
		var rcfg_path = p.replace("plugin.cfg", "rakugo.cfg")
		var plugin_dir = p.replace("plugin.cfg", "")
		if file.file_exists(rcfg_path):
			prints("found Rakugo plugin:", rcfg_path)
			rcfg.load(rcfg_path)

			if rcfg.has_section_key("rakugo-plugin", "types"):
				types.append_array(rcfg.get_value("rakugo-plugin", "types", []))

			if rcfg.has_section_key("rakugo-plugin", "controls"):
				var controls : Dictionary = rcfg.get_value("rakugo-plugin", "controls")
				for c in controls.keys():
					var scene : PackedScene = load(plugin_dir + c)
					var control = scene.instance()
					controls_dir[c] = control
					add_control_to_container(CONTAINER_TOOLBAR, control)
				
			if rcfg.has_section_key("rakugo-plugin", "menu"):
				var menu : Dictionary = rcfg.get_value("rakugo-plugin", "menu")
				for m in menu.keys():
					popup.add_item(m)
					var control = controls_dir[menu[m].scene]
					var method = menu[m].method
					var arg = menu[m].arg
					menu_methods.append([control, method, arg])
					
	popup.connect("id_pressed", self, "_on_menu_item_pressed")
	add_control_to_container(CONTAINER_TOOLBAR, tools_menu)
	var p = tools_menu.get_parent()
	p.move_child(tools_menu, 0)

	print("Rakugo is enabled")

func _on_menu_item_pressed(id:int):
	var control = menu_methods[id][0]
	var method = menu_methods[id][1]
	var arg = menu_methods[id][2]
	var f = funcref(control, method)
	f.call_funcv([arg])

func _exit_tree():
	for c in controls_dir.keys():
		var control = controls_dir[c]
		remove_control_from_container(CONTAINER_TOOLBAR, control)
	
	remove_control_from_container(CONTAINER_TOOLBAR, tools_menu)

	for t in types:
		remove_custom_type(t)
	
	print("Rakugo is disabled")
