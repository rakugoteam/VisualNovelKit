extends Control

onready var SceneAnchor := $Panel/SceneAnchor
onready var Screens := $Panel/TabContainer/Screens
onready var InGameGUI := $Panel/TabContainer/InGameGUI
onready var Loading := $Panel/TabContainer/Loading
onready var QuitScreen := $Panel/QuitScreen


func _ready():
	Rakugo.current_scene_node = self
	
	OS.window_fullscreen = Settings.get(SettingsList.fullscreen)
	OS.window_maximized = Settings.get(SettingsList.maximized, false)
	if not OS.window_fullscreen and not OS.window_maximized:
		init_window_size()
		center_window()
	
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")


func init_window_size():
	if Settings.get(SettingsList.height) == 0:
		Settings.set(SettingsList.height, Settings.get(SettingsList.height, null, false, true))
	
	if Settings.get(SettingsList.width) == 0:
		Settings.set(SettingsList.width, Settings.get(SettingsList.width, null, false, true))
	
	var current_ratio = (1.0 * Settings.get(SettingsList.width)) / Settings.get(SettingsList.height)
	var default_ratio = (1.0 * Settings.get(SettingsList.width, null, false, true)) / Settings.get(SettingsList.height, null, false, true)
	
	if current_ratio < default_ratio:
		Settings.set(SettingsList.height, int(Settings.get(SettingsList.width) / default_ratio))

	elif current_ratio > default_ratio:
		Settings.set(SettingsList.width, int(default_ratio * Settings.get(SettingsList.height)))
	OS.window_size.x = Settings.get(SettingsList.width)
	OS.window_size.y = Settings.get(SettingsList.height)


func center_window():
	OS.window_position = (OS.get_screen_size(OS.current_screen) - OS.window_size) * 0.5

func _on_window_resized():
	Settings.set(SettingsList.fullscreen, OS.window_fullscreen)
	Settings.set(SettingsList.maximized, OS.window_maximized)

	if not OS.window_fullscreen and not OS.window_maximized:
		Settings.set(SettingsList.width, OS.window_size.x)
		Settings.set(SettingsList.height, OS.window_size.y)

func select_ui_tab(tab:int):
	$Panel/TabContainer.current_tab = tab

func get_current_ui():
	return $Panel/TabContainer.get_current_tab_control()
