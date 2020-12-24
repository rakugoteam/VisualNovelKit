<<<<<<< HEAD
extends RichTextLabel

func _ready():
	Rakugo.connect("say" ,self, "_on_say")


func _on_say(_character, _text, _parameters):
	if _character:
		self.bbcode_text = _character.get_composite_name("bbcode")
	else:
		self.bbcode_text = Rakugo.Say.get_narrator().name
=======
extends RichTextLabel

func _ready():
	Rakugo.connect("say", self, "_on_say")


func _on_say(_character, _text, _parameters):
	if _character:
		self.bbcode_text = _character.get_composite_name("bbcode")
	else:
		self.bbcode_text = Rakugo.Say.get_narrator().name
>>>>>>> f4a81ea87c9bba54a08d3ac43a556af80a7ac575
