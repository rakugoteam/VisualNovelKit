extends Control

func _on_Hide_pressed():
	Window.Tabs.get_child(1).hide()

func _on_History_pressed():
	_on_Hide_pressed()
	Window.Screens.show_page("history")

func _on_Back_pressed():
	pass # Replace with function body.

func _on_Skip_pressed():
	pass # Replace with function body.

func _on_Save_pressed():
	_on_Hide_pressed()
	Window.Screens.show_page("save")

func _on_Load_pressed():
	_on_Hide_pressed()
	Window.Screens.show_page("load")

func _on_Preferences_pressed():
	_on_Hide_pressed()
	Window.Screens.show_page("preferences")

func _on_Quit_pressed():
	_on_Hide_pressed()
	Window.Screens.show_page("quit")

func _process(delta):
	if Input.is_action_just_pressed("hide_ui"):
		var ui_visible = Window.Tabs.get_child(1).visible
		Window.Tabs.get_child(1).visible = not ui_visible
