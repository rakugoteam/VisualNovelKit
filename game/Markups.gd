extends Dialogue

export var intro_nodepath : NodePath
export var back_button_nodepath : NodePath

onready var parent : Control = get_parent() as Control
onready var back_button : Button = get_node(back_button_nodepath)
onready var intro : Dialogue = get_node(intro_nodepath)

func _ready():
	back_button.connect("pressed", self, "_on_back_button_pressed")

func _on_back_button_pressed():	
	parent.hide()
	intro.start()

func markups():
	start_event("markups")

	hide("dialogue")
	parent.show()

	end_event()
