extends HBoxContainer


signal change_page(page, incremental_change)


# Called when the node enters the scene tree for the first time.
func _ready():
	for b in get_children():
		b.connect("page_button_pressed", self, "_on_page_button_pressed")

func _on_page_button_pressed(action):
	match action:
		"<":
			emit_signal("change_page", 0, -1)
		">":
			emit_signal("change_page", 0, 1)
		"Q":
			emit_signal("change_page", 'Q', 0)
		_:
			emit_signal("change_page", int(action), 0)


func _on_page_changed():
	var page = Kit.saves_ui_page
	for b in get_children():
		if b.text == str(page):
			b.pressed = true
			continue
		
		if [b.text, page] == ["Q", -1]:
			b.pressed = true
			continue

		if [b.text, page] == ["A", -2]:
			b.pressed = true
			continue
		
		b.pressed = false
