extends PanelContainer

onready var ch_name := $VBoxContainer/CharacterName
onready var text := $VBoxContainer/Text


func init(entry):
	if entry.character_tag and Rakugo.store.get(entry.character_tag):
		ch_name.markup_text = Rakugo.store.get(entry.character_tag)
	else:
		 ch_name.markup_text = Rakugo.Say.get_narrator()
	if not ch_name.markup_text:
		ch_name.markup_text.visible = false
	text.markup_text = entry.text
