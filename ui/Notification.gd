extends Popup

func _ready():
	Rakugo.connect("notify", self, "_on_notify")

func _on_notify(text, parameters):
	pass
