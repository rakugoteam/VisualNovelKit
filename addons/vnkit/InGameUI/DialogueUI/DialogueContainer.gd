extends VBoxContainer

onready var dialog_label := $DialogLabel
onready var answer_edit := $AnswerEdit

func _ready() -> void:
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	Rakugo.connect("step", self, "_on_step")
	answer_edit.connect("text_entered", self, "_on_answer_entered")

func _on_say(character:Dictionary, text:String) -> void:
	show()
	if character.empty():
		character = Rakugo.get_narrator()
	
	var ch_name = character.get("name", "null")
	text = "# %s \n%s" % [ch_name, text]
	dialog_label.markup_text = text
	# prints("dialog_label:", dialog_label.bbcode_text)

func _on_step():
	dialog_label.markup_text += "\n@shake 5, 10 {Press 'Enter' to continue...}"
	# hide()

func _on_ask(character:Dictionary, question:String, default_answer:String) -> void:
	_on_say(character, question)
	answer_edit.show()
	answer_edit.grab_focus()
	answer_edit.placeholder_text = default_answer

func _on_ask_entered(answer:String) -> void:
	answer_edit.hide()
	answer_edit.placeholder_text = ""
	answer_edit.text = ""
	Rakugo.ask_return(answer)

func _process(delta) -> void:
	var ui_accept := Input.is_action_just_pressed("ui_accept")
	if Rakugo.is_waiting_step() and ui_accept:
		Rakugo.do_step()
		
		


