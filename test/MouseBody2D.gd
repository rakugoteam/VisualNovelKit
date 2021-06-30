tool
extends KinematicBody2D
class_name MouseBody2D, "res://addons/Rakugo/icons/mouse_button_2d.svg"

func _ready():
	for ch in get_children():
		if ch is CollisionShape2D:
			break
	
	add_collision()

func add_collision():
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 6
	collision.shape = shape
	collision.name = "CollisionShape2D"
	add_child(collision, true)
	print("add collision")

func _physics_process(delta):
	if !Engine.editor_hint:
		position = get_global_mouse_position()
