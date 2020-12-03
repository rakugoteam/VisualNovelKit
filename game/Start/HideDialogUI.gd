extends Dialogue

func _ready():
	default_starting_event = "hide_dialog_ui"

func hide_dialog_ui():
	start_event("hide_dialog_ui")
	hide("game_ui")
	end_event()
