tool
extends Button
class_name AdvancedTextButton

onready var adv_label := $AdvancedTextLabel

export(String, MULTILINE) var markup_text := "" setget _set_markup_text
export(String, "default", "markdown", "renpy", "bbcode") var markup := "default" setget _set_markup

var ready := false


func _ready():
	if !adv_label:
		adv_label = $AdvancedTextLabel

	adv_label.scroll_active = false
	adv_label.mouse_filter = MOUSE_FILTER_PASS
	adv_label.rect_clip_content = false
	_set_markup(markup)
	_set_markup_text(markup_text)

	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	connect("toggled", self, "_on_toggled")
	ready = true


func size_update():
	rect_min_size = adv_label.rect_min_size


func _set_markup_text(text: String):
	if Engine.editor_hint or !ready:
		return

	if !adv_label:
		return

	markup_text = text
	adv_label.markup_text = text
	yield(get_tree(), "idle_frame")
	size_update()


func _set_markup(markup: String):
	if Engine.editor_hint or !ready:
		return

	if !adv_label:
		return

	markup = markup
	adv_label.markup = markup
	yield(get_tree(), "idle_frame")
	size_update()


func _set_label_color(color_name: String):
	adv_label.modulate = get_color(color_name, "Button")


func _set(property: String, value) -> bool:
	if property in get_property_list():
		set(property, value)
	else:
		return false

	match property:
		"disabled":
			if value:
				_set_label_color("font_color_disabled")
			else:
				_set_label_color("font_color")

	return true


func is_toggled():
	return pressed and toggle_mode


func _on_mouse_entered():
	if not (disabled or is_toggled()):
		_set_label_color("font_color_hover")


func _on_mouse_exited():
	if not (disabled or is_toggled()):
		_set_label_color("font_color")


func _on_pressed():
	if not disabled:
		_set_label_color("font_color_pressed")


func _on_toggled(value: bool):
	if not disabled:
		if value:
			_set_label_color("font_color_pressed")
		else:
			_set_label_color("font_color")
