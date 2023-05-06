extends TabContainer

export(String, MULTILINE) var text := "[center][shake rate=5 level=10]**Clik to edit me**[/shake][/center]"
export var _button: NodePath
export var _edit: NodePath
export var _buttons_container: NodePath
export var _save_button: NodePath
export var _cancel_button: NodePath

var button: AdvancedTextButton
var m_edit: TextEdit
var buttons_container: Control
var save_button: Button
var cancel_button: Button


func _ready():
	button = get_node(_button)
	m_edit = get_node(_edit)
	buttons_container = get_node(_buttons_container)
	save_button = get_node(_save_button)
	cancel_button = get_node(_cancel_button)

	m_edit.text = text
	button.markup_text = text
	button.connect("pressed", self, "_on_button_pressed")
	save_button.connect("pressed", self, "_on_save_button_pressed")
	cancel_button.connect("pressed", self, "_on_cancel_button_pressed")


func _on_button_pressed():
	m_edit.text = button.markup_text
	m_edit.rect_min_size = button.rect_size
	current_tab = 1
	buttons_container.show()


func _on_save_button_pressed():
	button.markup_text = m_edit.text
	current_tab = 0
	buttons_container.hide()


func _on_cancel_button_pressed():
	m_edit.text = button.markup_text
	current_tab = 0
	buttons_container.hide()


func _process(delta):
	if current_tab == 1:
		if Input.is_key_pressed(KEY_ESCAPE):
			_on_cancel_button_pressed()
			return

		if Input.is_key_pressed(KEY_ENTER):
			if Input.is_key_pressed(KEY_MASK_SHIFT):
				m_edit.text += "\n"
				return

			_on_save_button_pressed()
