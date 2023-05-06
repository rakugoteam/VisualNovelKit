tool
extends Control

export(String, MULTILINE) var text := "[center][shake rate=5 level=10]**Clik to edit me**[/shake][/center]"
export(NodePath) onready var m_edit = get_node(m_edit)
export(NodePath) onready var button = get_node(button)


func _ready():
	button.markup_text = text
	m_edit.text = text
	button.connect("toggled", self, "_on_button_toggled")
	m_edit.connect("text_changed", self, "_on_text_changed")


func _on_button_toggled(toggled: bool):
	if toggled:
		var pos = button.rect_global_position
		pos.y += button.rect_size.y
		var r = $Popup.rect_size
		var rect = Rect2(pos, r)
		$Popup.popup(rect)

	else:
		$Popup.hide()


func _on_text_changed():
	button.markup_text = m_edit.text


func _process(delta):
	if $Popup.visible:
		if Input.is_key_pressed(KEY_ESCAPE):
			$Popup.hide()
			button.disabled = false
