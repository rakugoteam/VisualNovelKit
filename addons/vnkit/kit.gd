extends Node

# Kit
## Setting's strings
const auto_mode_delay = "addons/kit/auto_mode_delay"
const typing_effect_delay = "addons/kit/typing_effect_delay"
const skip_delay = "addons/kit/skip_delay"
const saves_ui_page = "addons/kit/saves/current_page"
const saves_ui_pages = "addons/kit/saves/page_names"
const saves_ui_layout = "addons/kit/saves/layout"
const saves_ui_scroll = "addons/kit/saves/scroll"
const saves_ui_skip_naming = "addons/kit/saves/skip_naming"

# Godot
## Setting's strings
const width = "display/window/size/width"
const height = "display/window/size/height"
const fullscreen = "display/window/size/fullscreen"
const maximized = "display/window/size/maximized"

var audio_buses := {}

func _ready():
	var audio_bus := [
		"Master",
		"BGM",
		"SFX",
		"Dialogs"
	]

	for bus_name in audio_bus:
		var bus_id = AudioServer.get_bus_index(bus_name)
		var mute = AudioServer.is_bus_mute(bus_id)
		var volume = AudioServer.get_bus_volume_db(bus_id)
		audio_buses[bus_name] = {"mute":mute, "volume": volume}
