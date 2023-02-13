extends ScrollContainer

export var choice_button_scene : PackedScene
onready var choices_box := $ChoicesBox

func _ready():
	Rakugo.connect("menu", self, "_on_menu")

func _on_choice_pressed(button:Button):
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
		button.markup = "markdown"
		button.markup_text = "@center{%s}" % choice
		button.connect("pressed", self, "_on_choice_pressed", [button])
		button.show()
	
	show()

func purge_children():
	for c in choices_box.get_children():
		choices_box.call_deferred('remove_child', c)
