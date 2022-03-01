extends ScrollContainer

export var choice_button_scene : PackedScene
var style := "vertical"

func _ready():
	Rakugo.connect("menu", self, "_on_menu")

func on_choice_button_pressed(_choice_button):
	var return_value = _choice_button.get_meta('return_value')
	purge_children()
	Rakugo.menu_return(return_value)

func _on_menu(choices:Array):
	purge_children()
	for i in choices.size():
		var button:Button = choice_button_scene.instance()
		button.rakugo_text = choices[i][0]
		self.add_child(button)
		button.connect("choice_button_pressed", self, "on_choice_button_pressed", i)

func purge_children():
	for c in self.get_children():
		self.call_deferred('remove_child', c)
