tool
extends RakugoPlugin

var tools_menu

var default_property_list = SettingsList.new().default_property_list

func _enter_tree():
	for property_key in default_property_list.keys():
		var property_value = default_property_list[property_key]
		ProjectTools.set_setting(property_key, property_value[0], property_value[1])
	
	ProjectSettings.set_order("rakugo/game/info/version", 1)

	var theme = get_editor_interface().get_base_control().theme

	tools_menu = "tools/menu/ToolsMenu.tscn"
	add_control(CONTAINER_TOOLBAR, tools_menu)
	print("Rakugo is enabled")

