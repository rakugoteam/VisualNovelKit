extends Dialogue

export var intro_nodepath : NodePath
export var back_button_nodepath : NodePath

onready var back_button : Button = get_node(back_button_nodepath)

func _ready():
	back_button.connect("pressed", self, "_on_back_button_pressed")

func _on_back_button_pressed():	
	jump("Tutorial", "Dialogue", "intro")

func markups():
	start_event("markups")

	hide("dialogue")

	end_event()
