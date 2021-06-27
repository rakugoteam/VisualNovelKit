extends KinematicBody2D


func _physics_process(delta):
	position = get_global_mouse_position()
