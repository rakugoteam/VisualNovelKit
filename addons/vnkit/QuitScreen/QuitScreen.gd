extends Panel

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		visible = true

func _on_visibility_changed():
	# Using self connected signal to also handle external use
	if visible:
		$QuitConfirmDialog.call_deferred("popup_centered")

func _on_popup_hide():
	visible = false
	# prevent the input that cancelled quitting to trigger the step
	yield(get_tree().create_timer(0.1), "timeout")
