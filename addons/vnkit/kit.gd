# Kit
extends Node

var kit_settings := {
	auto_mode_delay = "addons/kit/auto_mode_delay",
	typing_effect_delay = "addons/kit/typing_effect_delay",
	skip_delay = "addons/kit/skip_delay",
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

var game_started = false
var auto_mode_delay = 0.0 setget set_auto_mode_delay, get_auto_mode_delay
var typing_effect_delay = 0.0 setget set_typing_effect_delay, get_typing_effect_delay
var skip_delay = 0.0 setget set_skip_delay, get_skip_delay
var width = 0 setget set_width, get_width
var height = 0 setget set_height, get_height
var fullscreen = false setget set_fullscreen, get_fullscreen
var maximized = false setget set_maximized, get_maximized

func set_auto_mode_delay(value:float):
	auto_mode_delay = value
	ProjectSettings.set_setting(kit_settings.auto_mode_delay, value)

func get_auto_mode_delay() -> float:
	return auto_mode_delay

func set_typing_effect_delay(value:float):
	typing_effect_delay = value
	ProjectSettings.set_setting(kit_settings.typing_effect_delay, value)

func get_typing_effect_delay() -> float:
	return typing_effect_delay

func set_skip_delay(value:float):
	skip_delay = value
	ProjectSettings.set_setting(kit_settings.skip_delay, value)

func get_skip_delay() -> float:
	return skip_delay

func set_width(value:int):
	width = value
	ProjectSettings.set_setting(godot_settings.width, value)

func get_width() -> int:
	return width

func set_height(value:int):
	height = value
	ProjectSettings.set_setting(godot_settings.height, value)

func get_height() -> int:
	return height

func set_fullscreen(value:bool):
	fullscreen = value
	ProjectSettings.set_setting(godot_settings.fullscreen, value)

func get_fullscreen() -> bool:
	return fullscreen

func set_maximized(value:bool):
	maximized = value
	ProjectSettings.set_setting(godot_settings.maximized, value)

func get_maximized() -> bool:
	return maximized

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
