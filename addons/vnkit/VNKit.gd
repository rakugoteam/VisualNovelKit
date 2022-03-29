extends Node

# VNKit
## Setting's strings
const auto_mode_delay = "addons/vnkit/auto_mode_delay"
const typing_effect_delay = "addons/vnkit/typing_effect_delay"
const skip_delay = "addons/vnkit/skip_delay"
const saves_ui_page = "addons/vnkit/saves/current_page"
const saves_ui_pages = "addons/vnkit/saves/page_names"
const saves_ui_layout = "addons/vnkit/saves/layout"
const saves_ui_scroll = "addons/vnkit/saves/scroll"
const saves_ui_skip_naming = "addons/vnkit/saves/skip_naming"

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
