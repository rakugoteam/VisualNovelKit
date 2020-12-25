extends PanelContainer

export var is_active = false

func _ready():
	visible = is_active
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")

func _on_say(_character, _text, _parameters):
	if is_active:
		show()

func _on_ask(_default_answer, _parameters):
	if is_active:
		show()

func _step():
	if is_active:
		hide()

func _show(tag, args):
	is_active = true

func _hide():
	is_active = false
	hide()
