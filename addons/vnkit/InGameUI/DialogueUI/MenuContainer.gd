extends ScrollContainer

export var choice_button_scene : PackedScene
onready var choices_box := $ChoicesBox

func _ready():
	Rakugo.connect("menu", self, "_on_menu")

func on_choice_button_pressed(button:Button):
	Rakugo.menu_return(button.get_index())
	hide()

func _on_menu(choices:Array):
	purge_children()
	for choice in choices:
		var button : AdvancedTextButton
		button = choice_button_scene.instance()
		button.hide()
		# adding to container must be first
		choices_box.add_child(button)
		# or else the text won't be set
		button.set_markup("markdown")
		button.set_markup_text("@center{" + choice + "}")
		button.connect("pressed", self, "on_choice_button_pressed", [button])
		button.show()
	
	show()

func purge_children():
	for c in choices_box.get_children():
		choices_box.call_deferred('remove_child', c)
