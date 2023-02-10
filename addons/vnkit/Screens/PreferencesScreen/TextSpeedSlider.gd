extends Slider

func _on_value_changed(value):
	Kit.typing_effect_delay = abs(value)

func _on_visibility_changed():
	if visible and Kit.typing_effect_delay:
		value = -Kit.typing_effect_delay
