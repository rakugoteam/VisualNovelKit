extends Dialogue

export var intro_nodepath : NodePath
export var options_nodepath : NodePath
export var back_button_nodepath : NodePath
export var tabs_nodepath : NodePath
export var rakugo_text_label_nodepath : NodePath

onready var parent : Control = get_parent() as Control
onready var options : OptionButton = get_node(options_nodepath)
onready var back_button : Button = get_node(back_button_nodepath)
onready var tabs : TabContainer = get_node(tabs_nodepath)
onready var rakugo_text_label : RakugoTextLabel = get_node(rakugo_text_label_nodepath)
onready var intro : Dialogue = get_node(intro_nodepath)

var markup_id := 0
var code_edit : CodeEdit

func _ready():
		options.connect("item_selected", self, "_on_option_selected")
		switch_tab()
		back_button.connect("pressed", self, "_on_back_button_pressed")

func switch_tab(id:= 0):
	var text := ""
	var caret_pos := 0
	
	if code_edit != null:
		text = code_edit.text
		caret_pos = code_edit.caret_position

		if code_edit.is_connected("text_changed", self, "_on_text_changed"):
			code_edit.disconnect("text_changed", self, "_on_text_changed")
		
	tabs.current_tab = id
	code_edit = tabs.get_current_tab_control() as CodeEdit
	code_edit.text = text
	code_edit.caret_position = caret_pos
	code_edit.connect("text_changed", self, "_on_text_changed")

func _on_option_selected(id: int):
	if id != markup_id:
		switch_tab(id)
		var markup = options.get_item_text(id)
		rakugo_text_label.markup = markup.to_lower()

	rakugo_text_label.rakugo_text = code_edit.text

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
