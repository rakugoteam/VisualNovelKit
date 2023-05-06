tool
extends AdvancedTextLabel

func _ready():
	if Engine.editor_hint:
		return

	connect("meta_clicked", self, "_on_meta_clicked")
	connect("meta_hover_started", self, "_on_meta_hover_started")
	connect("meta_hover_ended", self, "_on_meta_hover_ended")

func _on_meta_hover_started(meta:String):
	Input.set_default_cursor_shape(CURSOR_POINTING_HAND)

func _on_meta_hover_ended(meta:String):
	Input.set_default_cursor_shape(CURSOR_ARROW)

func _on_meta_clicked(meta:String):
	if meta.begins_with("http"):
		OS.shell_open(meta)
	
