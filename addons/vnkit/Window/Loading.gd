extends Control


func _ready():
	hide()
	Rakugo.connect("loading", self, '_on_loading')

func _on_loading(progress:float):
	if progress == 1:
		hide()
	else:
		show()
	print("Loading progress is %s"%progress)
