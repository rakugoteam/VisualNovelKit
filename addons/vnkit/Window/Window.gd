extends CanvasLayer

onready var Tabs := $Panel/Tabs
onready var Screens := $Panel/Tabs/Screens
onready var QuitScreen := $Panel/QuitScreen

var fullscreen : bool setget _set_fullscreen, _get_fullscreen

func _set_fullscreen(value:bool):
	ProjectSettings.set_setting(VNKit.fullscreen, value)

func _get_fullscreen() -> bool:
	return ProjectSettings.get_setting(VNKit.fullscreen)

func _ready():
	OS.window_fullscreen = fullscreen
	OS.window_maximized = ProjectSettings.get_setting(VNKit.maximized)
	if not OS.window_fullscreen and not OS.window_maximized:
		center_window()
	
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")

func get_window_setting(setting:String) -> float:
	return ProjectSettings.get_setting(setting) * 1.0

func center_window():
	var size = OS.get_screen_size(OS.current_screen)
	OS.window_position = (size - OS.window_size) * 0.5

func _on_window_resized():
	fullscreen = OS.window_fullscreen
	ProjectSettings.set_setting(VNKit.maximized, OS.window_maximized)
	if not OS.window_fullscreen and not OS.window_maximized:
		ProjectSettings.set_setting(VNKit.width, OS.window_size.x)
		ProjectSettings.set_setting(VNKit.height, OS.window_size.y)

func select_ui_tab(tab:int):
	Tabs.current_tab = tab

func get_current_ui():
	return Tabs.get_current_tab_control()
