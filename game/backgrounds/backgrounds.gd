extends Node2D

func _show(tag, args):
	var tags = tag.split(" ", false, 1)
	show_or_hide(self, tags[1])


func show_or_hide(parten_node, node_name):
	for ch in parten_node.get_children():
		if ch.has_method("hide") and ch.has_method("show"):
			if ch.name.to_lower() == node_name:
				ch.show()
			else:
				ch.hide()

