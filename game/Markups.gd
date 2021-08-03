extends Dialogue

export var intro_nodepath : NodePath
export var options_nodepath : NodePath
export var back_button_nodepath : NodePath
export var text_edit_nodepath : NodePath
export var rakugo_text_label_nodepath : NodePath

onready var parent : Control = get_parent() as Control
onready var options : OptionButton = get_node(options_nodepath)
onready var back_button : Button = get_node(back_button_nodepath)
onready var text_edit : TextEdit = get_node(text_edit_nodepath)
onready var rakugo_text_label : RakugoTextLabel = get_node(rakugo_text_label_nodepath)
onready var intro : Dialogue = get_node(intro_nodepath)

var markup_id := 0

func _ready():
		options.connect("item_selected", self, "_on_option_selected")
		text_edit.connect("text_changed", self, "_on_text_changed")
		back_button.connect("pressed", self, "_on_back_button_pressed")

func _on_option_selected(id: int):
	if id != markup_id:
		var markup = options.get_item_text(id)
		rakugo_text_label.markup = markup.to_lower()

	rakugo_text_label.rakugo_text = text_edit.text

func _on_text_changed():
	var id = options.get_selected_id()
	_on_option_selected(id)

func _on_back_button_pressed():	
	parent.hide()
	intro.start()

func markups():
	start_event("markups")

	hide("dialogue")
	parent.show()

	end_event()
