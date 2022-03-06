tool
class_name ProjectTools
extends Reference
# author: willnationsdev & jeremi360
# license: MIT
# description: A utility for any features useful in the context of a Godot Project.

static func set_setting(p_name: String, p_default_value, p_pinfo: PropertyInfo) -> void:
	p_pinfo.name = p_name
	if not ProjectSettings.has_setting(p_name):
		ProjectSettings.set_setting(p_name, p_default_value)

	ProjectSettings.add_property_info(p_pinfo.to_dict())
	ProjectSettings.set_initial_value(p_name, p_default_value)

static func set_settings_dict(settings_dict:Dictionary) -> void:
	for property_key in settings_dict.keys():
		var property_value = settings_dict[property_key]
		set_setting(property_key, property_value[0], property_value[1])

static func set_settings_order(properties: Array, p_order: int) -> void:
	for p in properties:
		ProjectSettings.set_order(p, p_order)
		p_order += 1