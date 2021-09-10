tool
extends Label

func _on_emoji_selected(emoji_name):
	self.text = emoji_name + " copied"
	$Timer.start(2)

func _on_timeout():
	self.text = ""
