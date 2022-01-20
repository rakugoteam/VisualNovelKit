extends VBoxContainer

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	Rakugo.connect("step", self, "_on_step")

func _on_say(character, text, parameters):
	# todo make line below work
	# $DialogLabel.variables = Rakugo.variables
	$DialogLabel.markup_text = "# %s \n" % character.name  
	$DialogLabel.markup_text += text

func _on_step():
	printt("\nPress 'Enter' to continue...\n")

func _on_ask(default_answer, parameters):
	$AnswerEdit.show()
	$AnswerEdit.grab_focus()
	$AnswerEdit.placeholder_text = default_answer

func _process(delta):
	if Rakugo.is_waiting_step and Input.is_action_just_pressed("ui_accept"):
		Rakugo.do_step()
		
	if Rakugo.is_waiting_ask_return and Input.is_action_just_pressed("ui_down"):
		Rakugo.ask_return("Bob")

