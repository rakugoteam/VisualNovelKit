tool
extends WindowDialog

export var grid_node_path : NodePath
export var label_node_path : NodePath

export var grid_bound := 0.9
export var button_x := 36

onready var grid := get_node(grid_node_path) as GridContainer
onready var label := get_node(label_node_path) as Label

func _ready():
	label.hide()
	connect("resized" , self, "_on_resized")
	for button in grid.get_children():
		button.connect("pressed", self, "_on_button", [button])
	_on_resized()

func _on_button(b):
	OS.clipboard = b.name
	label.text = "Copied to Clipboard: " + b.name
	label.show()
	$Tween.interpolate_property(label, "modulate", Color.green, Color.transparent, 2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	label.hide()

func _on_resized():
	if button_x > 0:
		grid.columns = int((rect_size.x / button_x)*grid_bound)
