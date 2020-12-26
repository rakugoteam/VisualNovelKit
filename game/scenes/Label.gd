extends Label

func _show(tag, args):
	if text in args:
		text = args.text

