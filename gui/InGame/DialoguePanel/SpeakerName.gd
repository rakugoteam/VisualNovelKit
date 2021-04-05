extends RichTextLabel


# now its called from DialoguePanel
func _on_say(_character, _text, _parameters):
	if _character:
		self.bbcode_text = _character.get_composite_name("bbcode")
		return
	
	self.bbcode_text = Rakugo.Say.get_narrator().name
