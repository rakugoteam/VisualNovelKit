extends Popup

onready var label : AdvancedTextLabel = $Panel/Label
onready var timer : Timer = $Timer

func _ready():
	Rakugo.connect("notify", self, "_on_notify")
	timer.connect("timeout", self, "hide")

func _on_notify(text):
	show()
	# TODO: make line below work
	# label.variables = Rakugo.variables
	label.markup_text = text
