extends ScrollContainer

signal scroll(scroll_value)

func _ready():
	get_v_scrollbar().connect("scrolling", self, "_on_scroll")

func _on_scroll():
	ProjectSettings.set_setting(VNKit.saves_ui_scroll, self.scroll_vertical)

func _on_visibility_changed():
	self.scroll_vertical = ProjectSettings.get_setting(VNKit.saves_ui_scroll)
