tool
extends Label

func _ready():
	hide()

func _on_emoji_selected(emoji_name):
	self.text = emoji_name + " copied"
	show()
	$Timer.start(2)

func _on_timeout():
	hide()
	self.text = ""
