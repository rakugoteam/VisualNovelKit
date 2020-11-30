extends Label


func _show(tag, args):
	text = tag.split(" ", false, 1)[1]
	show()

