extends VBoxContainer

onready var dialog_label := $DialogLabel
onready var answer_edit := $AnswerEdit

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	Rakugo.connect("step", self, "_on_step")
	answer_edit.connect("text_entered", self, "_on_answer_entered")

func _on_say(character, text):
	show()
	# TODO: make line below work
	# $DialogLabel.variables = Rakugo.variables
	if character == null:
		character = Rakugo.get_narrator()

	text = "# " +  character.name + "\n" + text
	dialog_label.markup_text = text
	# prints("dialog_label:", dialog_label.bbcode_text)

func _on_step():
	dialog_label.markup_text += "\n@shake 5, 10 {Press 'Enter' to continue...}"
	# hide()

func _on_ask(character:Character, question:String, default_answer:String):
	_on_say(character, question)
	answer_edit.show()
	answer_edit.grab_focus()
	answer_edit.placeholder_text = default_answer

func _on_ask_entered(answer):
	answer_edit.hide()
	answer_edit.placeholder_text = ""
	answer_edit.text = ""
	Rakugo.ask_return(answer)

func _process(delta):
	var ui_accept := Input.is_action_just_pressed("ui_accept")
	if Rakugo.is_waiting_step() and ui_accept:
		Rakugo.do_step()
		
		


