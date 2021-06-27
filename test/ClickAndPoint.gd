extends Area2D


func _on_body_entered(body):
	prints(body.name, "is inside area")

func _on_body_exited(body):
	prints(body.name, "is out of area")