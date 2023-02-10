extends CheckButton


func _ready():
	var s = Kit.saves_ui_skip_naming


func _on_save_mode_changed(save_mode):
	visible = save_mode

func _on_toggled(button_pressed):
	Kit.saves_ui_skip_naming = button_pressed
