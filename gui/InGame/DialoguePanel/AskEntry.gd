extends LineEdit

var variable_name := ""

# now its called from DialoguePanel
func _on_ask(default_answer, _parameters):
	if _parameters.has('placeholder'):
		self.placeholder_text = _parameters['placeholder']
		
	self.text = default_answer
	show()


func _on_AskEntry_visibility_changed() -> void:
	var current_focus_control = get_focus_owner()
	if current_focus_control != self:
		if current_focus_control != null:
			current_focus_control.release_focus()
		
		grab_focus()
		caret_position = text.length()


func _on_text_entered(new_text):
	hide()
	Rakugo.ask_return(new_text)

