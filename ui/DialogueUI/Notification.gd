extends Popup

onready var label : AdvancedTextLabel = $Panel/Label
onready var timer : Timer = $Panel/Timer

func _ready():
	Rakugo.connect("notify", self, "_on_notify")
	timer.connect("timeout", self, "hide")

func _on_notify(text, parameters):
	show()
	# todo make line below work
	# label.variables = Rakugo.variables
	label.markup_text = text
	
	var t := 1 
	if "time" in parameters:
		t = parameters["time"]
	timer.start(t)
