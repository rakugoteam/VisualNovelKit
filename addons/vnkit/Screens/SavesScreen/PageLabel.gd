extends LineEdit

var current_page = 0

func _on_page_changed():
	current_page = Kit.saves_ui_page
	var saves_page_names = Kit.saves_ui_pages
	if current_page in saves_page_names:
		text = saves_page_names[current_page]
	else:
		match current_page:
			-1:
				self.editable = false
				text = "Quick saves"
			-2:
				self.editable = false
				text = "Automatic saves"
			_:
				text = "Page " + str(current_page)


func _on_text_changed(new_text):
	var saves_page_names = Kit.saves_ui_pages
	saves_page_names[current_page] = new_text
