extends TabContainer

export (Array, String) var active_tabs := [
	"Screens",
	"InGameUI",
	"Loading"
]

func _ready():
	for tab in get_children():
		if tab.name in active_tabs:
			pass
		else:
			tab.queue_free()
