extends RakugoTextLabel


# now its called from DialoguePanel
func _on_say(_character, _text:="", _parameters:={}):
	self.markup = _parameters.get("markup", "")

	if _character:
		self.rakugo_text = _character.get_composite_name("bbcode")
		return
	
	self.rakugo_text = Rakugo.Say.get_narrator().name
