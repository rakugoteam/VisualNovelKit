extends PanelContainer
export var style = "default"

signal say(character, text, parameters)
signal ask(default_answer, parameters)

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	hide()

func is_style_correct( _parameters) -> bool:
	if _parameters.has("style"):
		if _parameters["style"] == style:
			return true
			
	return false
		
func _on_say(_character, _text, _parameters):
	hide()
	
	if !is_style_correct(_parameters):
		return
	
	$HideTimer.stop()
	show()
	emit_signal("say", _character, _text, _parameters)


func _on_ask(_default_answer, _parameters):
	hide()
	
	if !is_style_correct(_parameters):
		return

	$HideTimer.stop()
	show()
	emit_signal("ask", _default_answer, _parameters)

func _step():
	$HideTimer.start()

func _on_HideTimer_timeout():
	hide()
