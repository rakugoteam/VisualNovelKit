tool
extends EditorPlugin


func _enter_tree():
	
	
	if !ProjectSettings.has_setting("addons/kit/auto_mode_delay"):
		ProjectSettings.set_setting("addons/kit/auto_mode_delay", 3)

	if !ProjectSettings.has_setting("addons/kit/skip_delay"):
		ProjectSettings.set_setting("addons/kit/skip_delay", 0.5)

	if !ProjectSettings.has_setting("addons/kit/typing_effect_delay"):
		ProjectSettings.set_setting("addons/kit/typing_effect_delay", 0.05)

	if ProjectSettings.has_setting("display/window/size/maximized"):
		ProjectSettings.set_setting("display/window/size/maximized", false)

	ProjectSettings.add_property_info(
		{
			"name": "addons/kit/saves/layout",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "pages, list"
		}
	)

	ProjectSettings.set_order("addons/kit/auto_mode_delay", 0)

	add_autoload_singleton("Kit", "res://addons/vnkit/kit.gd")
	add_autoload_singleton("Window", "res://addons/vnkit/Window/Window.tscn")


func _exit_tree():
	remove_autoload_singleton("Kit")
	remove_autoload_singleton("Window")
	ProjectSettings.set_setting("addons/kit/auto_mode_delay", null)
	ProjectSettings.set_setting("addons/kit/skip_delay", null)
	ProjectSettings.set_setting("addons/kit/typing_effect_delay", null)

	ProjectSettings.set_setting("display/window/size/maximized", null)
