# Kit
extends Node

var kit_settings := {
	auto_mode_delay = "addons/kit/auto_mode_delay",
	typing_effect_delay = "addons/kit/typing_effect_delay",
	skip_delay = "addons/kit/skip_delay",
	saves_ui_page = "addons/kit/saves/current_page",
	saves_ui_pages = "addons/kit/saves/page_names",
	saves_ui_layout = "addons/kit/saves/layout",
	saves_ui_scroll = "addons/kit/saves/scroll",
	saves_ui_skip_naming = "addons/kit/saves/skip_naming",
}

var godot_settings := {
	width = "display/window/size/width",
	height = "display/window/size/height",
	fullscreen = "display/window/size/fullscreen",
	maximized = "display/window/size/maximized",
}

var audio_bus := [
	"Master",
	"BGM",
	"SFX",
	"Dialogs"
]

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	var f :=  File.new()
	if f.file_exists("user://kit_config.cfg"):
		load_conf()

func set_audio_bus(bus_name:String, volume:float, mute := false):
	var bus_id = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_id, mute)
	AudioServer.set_bus_volume_db(bus_id, volume)

func get_audio_bus(bus_name:String):
	var bus_id = AudioServer.get_bus_index(bus_name)
	var mute = AudioServer.is_bus_mute(bus_id)
	var volume = AudioServer.get_bus_volume_db(bus_id)
	return {"mute":mute, "volume": volume}

func has(property:String) -> bool:
	if property in kit_settings:
		return ProjectSettings.has_setting(kit_settings[property])
	
	if property in godot_settings:
		return ProjectSettings.has_setting(godot_settings[property])
	
	return false

func _set(property:String, value) -> bool:
	if property in kit_settings:
		ProjectSettings.set_setting(kit_settings[property], value)
		return true
	
	if property in godot_settings:
		ProjectSettings.set_setting(godot_settings[property], value)
		return true
	
	return false

func _get_property_list():
	var list = []
	list.append_array(kit_settings.keys())
	list.append_array(godot_settings.keys())
	return list

func _get(property : String):
	if property in kit_settings:
		return ProjectSettings.get_setting(kit_settings[property])
	
	if property in godot_settings:
		return ProjectSettings.get_setting(godot_settings[property])
	
	return null

func save_conf() -> void:
	var config := ConfigFile.new()

	# for setting in kit_settings:
	# 	var value = ProjectSettings.get(kit_settings[setting])
	# 	config.set_value("kit", setting, value)

	for setting in godot_settings:
		var value = ProjectSettings.get(godot_settings[setting])
		config.set_value("godot", setting, value) 

	for bus_name in audio_bus:
		var bus = get_audio_bus(bus_name)
		set_audio_bus(bus_name, bus.volume, bus.mute)
		config.set_value("audio/" + bus_name, "volume", bus.volume)
		config.set_value("audio/" + bus_name, "mute", bus.mute)

	config.save("user://kit_config.cfg")

func load_conf() -> int:
	var config = ConfigFile.new()
	var error = config.load("user://kit_config.cfg")

	if error != OK:
		prints("Error loading config file:", error)
		return error
	
	# for setting in kit_settings:
	# 	var value = config.get_value("kit", setting)
	# 	if value != null:
	# 		ProjectSettings.set_setting(kit_settings[setting], value)
			
	for setting in godot_settings:
		var value = config.get_value("godot", setting)
		if value != null:
			ProjectSettings.set_setting(godot_settings[setting], value)
			
	for bus_name in audio_bus:
		var bus = get_audio_bus(bus_name)
		var volume = config.get_value("audio/" + bus_name, "volume")
		var mute = config.get_value("audio/" + bus_name, "mute")
		if volume != null:
			set_audio_bus(bus_name, volume, mute)

	return error
