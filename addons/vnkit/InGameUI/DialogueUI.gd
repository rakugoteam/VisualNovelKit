extends Control

export (Array, String) var active_children := [
	"DialogueUI",
	"MenuContainer"
]

func _ready():
	for ch in get_children():
		if ch.name in active_children:
			pass
		else:
			ch.queue_free()

