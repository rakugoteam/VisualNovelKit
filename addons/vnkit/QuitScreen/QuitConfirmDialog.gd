extends AcceptDialog

func _ready():
	get_ok().text = "Yes"
	add_cancel("No")
	connect("confirmed", self, "_on_confirm_pressed")

func _on_confirm_pressed():
	get_tree().quit()
