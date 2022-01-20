extends ScrollContainer

export var choice_button_scene : PackedScene

func _ready():
	Rakugo.connect("menu", self, "_on_menu")

func _on_menu(choices, parameters):
	pass
