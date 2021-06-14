extends Area2D

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	$Button.connect("pressed", self, "_on_button") 

func _on_mouse_entered():
	print("mouse in")

func _on_mouse_exited():
	print("mouse out")

func _on_button():
	print("clicked")
