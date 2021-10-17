tool
extends LineEdit

export var grid_node_path : NodePath
onready var grid := get_node(grid_node_path) as GridContainer

func _ready():
	connect("text_changed", self, "_on_text_changed")

func _on_text_changed(new_text):
	if new_text == '':
		for b in grid.get_children():
			b.show()
	else:
		for b in grid.get_children():
			if new_text in b.name:
				b.show()
			else:
				b.hide()