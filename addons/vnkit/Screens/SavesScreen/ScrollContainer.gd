extends ScrollContainer

signal scroll(scroll_value)

func _ready():
	get_v_scrollbar().connect("scrolling", self, "_on_scroll")

func _on_scroll():
	Kit.saves_ui_scroll = self.scroll_vertical

func _on_visibility_changed():
	if Kit.saves_ui_scroll:
		self.scroll_vertical = Kit.saves_ui_scroll
