extends Control

signal show_menu(menu, game_started)
signal show_main_menu_confirm()

func _ready():
	# get_tree().paused = true
	get_tree().set_auto_accept_quit(false)
	Rakugo.connect("game_ended", self, "_on_game_end")
	connect("visibility_changed", self, "_on_visibility_changed")

func _on_nav_button_press(nav):
	match nav:
		"start":
			Window.select_ui_tab(1)
			Rakugo.start()

		"continue":
			if !Rakugo.loadfile("auto"):
				return
			else:
				Window.select_ui_tab(1)

		"save":
			save_menu(get_screenshot())

		"load":
			load_menu()

		"main_menu":
			if Rakugo.started:
				emit_signal("show_main_menu_confirm")
			else:
				show_page(nav)

		"return":
			if Rakugo.started:
				Window.select_ui_tab(1)
			else:
				show_page(nav)

		"quit":
			Window.QuitScreen.show()

		_:
			show_page(nav)


const page_action_index:Dictionary = {
	'main_menu':0,
	'return':0,
	'about':1,
	'help':1,
	'history':2,
	'preferences':3,
	'save':4,
	'load':4
}

func show_page(action):
	emit_signal("show_menu", action, Rakugo.started)
	if action in page_action_index:
		$SubMenus.current_tab = page_action_index[action]
		Window.select_ui_tab(0)

func save_menu(screenshot):
	$SubMenus/SavesSlotScreen.save_mode = true
	$SubMenus/SavesSlotScreen.screenshot = screenshot
	show_page("save")

func load_menu():
	$SubMenus/SavesSlotScreen.save_mode = false
	show_page("load")

func _on_game_end():
	Window.select_ui_tab(0)

func get_screenshot():
	var screenshot:Image = get_tree().get_root().get_texture().get_data()
	screenshot.flip_y()
	return screenshot

func _screenshot_on_input(event):
	if !event.is_action_pressed("rakugo_screenshot"):
		return

	var dir = Directory.new()
	var screenshots_dir = "user://screenshots"

	if !dir.dir_exists(screenshots_dir):
		dir.make_dir(screenshots_dir)

	var datetime = OS.get_datetime()
	var s = "{day}-{month}-{year}_{hour}-{minute}-{second}.png".format(datetime)
	get_screenshot().save_png(screenshots_dir.plus_file(s))

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			_on_nav_button_press("return")

func _on_SavesSlotScreen_mode_changed(save_mode):
	if save_mode:
		emit_signal("show_menu", "save", Rakugo.started)
	else:
		emit_signal("show_menu", "load", Rakugo.started)
	
func _on_visibility_changed():
	get_tree().paused = visible
		
