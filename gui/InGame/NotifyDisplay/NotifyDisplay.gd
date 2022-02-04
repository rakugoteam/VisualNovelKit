extends PanelContainer

export var char_size := Vector2(5, 10)
export(float, 0, 1, 0.1) var fade_time := 0.3
export(float, 0.5, 3, 0.1) var base_duration := 2.0
export(float, 0, 0.5, 0.05) var duration_factor_per_word := 0.1

func _ready():
	Rakugo.connect("notify", self, "_on_notify")
	hide()

func _on_notify(text:String, parameters:Dictionary):
	$Label.rakugo_text = text
	$Label.resize_to_text(char_size)
	fade_in_out()

func fade_in_out():
	var splits = $Label.rakugo_text.split(" ", false)
	var wait_duration = base_duration * (1 + duration_factor_per_word * splits.size())
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, fade_time + wait_duration)
	$Tween.interpolate_deferred_callback(self, 2 * fade_time + wait_duration, "hide")
	$Tween.start()
	$Label.hide()#This is to reset the size of the panel
	show()
	$Label.show()
