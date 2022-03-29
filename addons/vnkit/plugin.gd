tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("VNKit", "res://addons/vnkit/VNKit.gd")
	if !ProjectSettings.has_setting("addons/vnkit/auto_mode_delay"):
		ProjectSettings.set_setting("addons/vnkit/auto_mode_delay", 3)
	
	if !ProjectSettings.has_setting("addons/vnkit/skip_delay"):
		ProjectSettings.set_setting("addons/vnkit/skip_delay", 0.5)

	if !ProjectSettings.has_setting("addons/rakugo/typing_effect_delay"):
		ProjectSettings.set_setting("addons/rakugo/typing_effect_delay", 0.05)

	if !ProjectSettings.has_setting("addons/vnkit/saves/current_page"):
		ProjectSettings.set_setting("addons/vnkit/saves/current_page", 0)
	
	if !ProjectSettings.has_setting("addons/vnkit/saves/page_names"):
		ProjectSettings.set_setting("addons/vnkit/saves/page_names", [])

	if !ProjectSettings.has_setting("addons/vnkit/saves/layout"):
		ProjectSettings.set_setting("addons/vnkit/saves/layout", "pages")
	
	ProjectSettings.add_property_info({
		"name": "addons/vnkit/saves/layout",
    "type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "pages, list"
	})
	
	if !ProjectSettings.has_setting("addons/vnkit/saves/current_scroll"):
		ProjectSettings.set_setting("addons/vnkit/saves/current_scroll", 0)

	if !ProjectSettings.has_setting("addons/vnkit/saves/skip_naming"):
		ProjectSettings.set_setting("addons/vnkit/saves/skip_naming", true)

	ProjectSettings.set_order("addons/vnkit/auto_mode_delay", 0)


func _exit_tree():
	ProjectSettings.set_setting("addons/vnkit/auto_mode_delay", null)
	ProjectSettings.set_setting("addons/vnkit/skip_delay", null)
	ProjectSettings.set_setting("addons/rakugo/typing_effect_delay", null)
	ProjectSettings.set_setting("addons/vnkit/saves/current_page", null)
	ProjectSettings.set_setting("addons/vnkit/saves/page_names", null)
	ProjectSettings.remove_property_info("addons/vnkit/saves/layout")
	ProjectSettings.set_setting("addons/vnkit/saves/layout", null)
	ProjectSettings.set_setting("addons/vnkit/saves/current_scroll", null)
	ProjectSettings.set_setting("addons/vnkit/saves/skip_naming", null)

