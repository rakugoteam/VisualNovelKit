extends RayCast2D

func _process(delta):
	position = get_global_mouse_position();
	if Input.is_action_just_pressed("ui_accept"):
		if is_colliding():
			pass
