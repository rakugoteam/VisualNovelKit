extends PanelContainer

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")

func _on_say(_character, _text, _parameters):
	$HideTimer.stop()
	show()

func _on_ask(_default_answer, _parameters):
	$HideTimer.stop()
	show()

func _step():
	$HideTimer.start()

func _on_HideTimer_timeout():
	hide()
