extends VBoxContainer

onready var dialog_label : AdvancedTextLabel = $DialogLabel
onready var answer_edit : LineEdit = $AnswerEdit
var is_waiting_step := false

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	answer_edit.connect("text_entered", self, "_on_answer_entered")
	Rakugo.connect("step", self, "_on_step")

func _on_say(character, text):
	show()
	# TODO: make line below work
	# $DialogLabel.variables = Rakugo.variables
	if character == null:
		character = Rakugo.get_narrator()

	dialog_label.markup_text = "# %s \n" % character.name 
	dialog_label.markup_text += text

func _on_step():
	hide()
	is_waiting_step = true

func _on_ask(default_answer):
	answer_edit.show()
	answer_edit.grab_focus()
	answer_edit.placeholder_text = default_answer

func _on_ask_entered(answer):
	answer_edit.hide()
	answer_edit.placeholder_text = ""
	answer_edit.text = ""
	Rakugo.ask_return(answer)

func _process(delta):
	if is_waiting_step and Input.is_action_just_pressed("ui_accept"):
		is_waiting_step = false
		Rakugo.current_parser.step_semaphore.post()
		
		


