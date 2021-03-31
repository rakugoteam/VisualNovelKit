extends PanelContainer
export var style = "default"

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")

func _on_say(_character, _text, _parameters):
	hide()
	
	if _parameters.has("style"):
		if _parameters["style"] != style:
			return;

	$HideTimer.stop()
	show()

func _on_ask(_default_answer, _parameters):
	hide()
	
	if _parameters.has("style"):
		if _parameters["style"] != style:
			return;

	$HideTimer.stop()
	show()

func _step():
	$HideTimer.start()

func _on_HideTimer_timeout():
	hide()
