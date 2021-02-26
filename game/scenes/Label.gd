extends Label

func _show(tag: String, args: Dictionary):
	if args.has("text"):
		set_text(args["text"])
	show()

