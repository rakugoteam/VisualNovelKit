extends Node2D
class_name Screen2D

## used to identify the screen alternative to using the name of the node
## useful when you spawn a screen from a script in runtime
export var screen_name := ""

func _ready():
	Screens.connect("show", self, "_on_show")
	Screens.connect("at", self, "_on_at")
	Screens.connect("with", self, "_on_with")

func show_node(screen_path:Array, node:Node2D, shown:bool):
	# show all nodes in the screen_path if shown is true
	# but if shown is false, hide only last node in the screen_path
	if node is Node2D:
		if node.name == screen_path[0]:
			if shown:
				node.visible = true
			elif screen_path.size() == 1:
				node.visible = false
				return
	
	if node is Screen2D:
		if screen_path[0] in [node.name, node.screen_name]:
			if shown:
				node.visible = true
			elif screen_path.size() == 1:
				node.visible = false
				return

	if screen_path.size() > 1:
		screen_path.pop_front()
		for child in node.get_children():
			if child is Screen2D:
				child.show_node(screen_path, child, shown)
				return

			if child is Node2D:
				if child.name == screen_path[0]:
					show_node(screen_path, child, shown)
					screen_path.pop_front()
					continue

func pos_node_at(screen_path:Array, node:Node2D, pos):
	# set pos only of last node in the screen_path
	var name_is_correct = false
	if node is Node2D:
		if node.name == screen_path[0]:
			name_is_correct = true
			if screen_path.size() == 1:
				if pos is Vector2:
					node.position = pos

				if pos is Vector3:
					node.position = pos.xy

				if pos is String:
					node.position = get_node(pos).position

				return
			
	if node is Screen2D:
		if screen_path[0] in [node.name, node.screen_name]:
			name_is_correct = true
			if screen_path.size() == 1:
				if pos is Vector2:
					node.position = pos

				if pos is Vector3:
					node.position = pos.xy

				if pos is String:
					node.position = get_node(pos).position

				return
	
	if screen_path.size() > 1 and name_is_correct:
		screen_path.pop_front()
		for child in node.get_children():
			if child is Screen2D:
				child.pos_node_at(screen_path, child, pos)
				return

			if child is Node2D:
				if child.name == screen_path[0]:
					pos_node_at(screen_path, child, pos)
					screen_path.pop_front()
					continue

func scale_node(screen_path:Array, node:Node2D, scale:Vector2):
	# set scale only of last node in the screen_path
	var name_is_correct = false
	if node is Node2D:
		if node.name == screen_path[0]:
			name_is_correct = true
			if screen_path.size() == 1:
				node.scale = scale
				return
	
	if node is Screen2D:
		if screen_path[0] in [node.name, node.screen_name]:
			name_is_correct = true
			if screen_path.size() == 1:
				node.scale = scale
				return
	
	if screen_path.size() > 1 and name_is_correct:
		screen_path.pop_front()
		for child in node.get_children():
			if child is Screen2D:
				child.scale_node(screen_path, child, scale)
				return

			if child is Node2D:
				if child.name == screen_path[0]:
					scale_node(screen_path, child, scale)
					screen_path.pop_front()
					continue

func rotate_node(screen_path:Array, node:Node2D, angle:float):
	# set angle only of last node in the screen_path
	var name_is_correct = false
	if node is Node2D:
		if node.name == screen_path[0]:
			name_is_correct = true
			if screen_path.size() == 1:
				node.rotation = angle
				return
	
	if node is Screen2D:
		if screen_path[0] in [node.name, node.screen_name]:
			name_is_correct = true
			if screen_path.size() == 1:
				node.rotation = angle
				return
	
	if screen_path.size() > 1 and name_is_correct:
		screen_path.pop_front()
		for child in node.get_children():
			if child is Screen2D:
				child.rotate_node(screen_path, child, angle)
				return

			if child is Node2D:
				if child.name == screen_path[0]:
					rotate_node(screen_path, child, angle)
					screen_path.pop_front()
					continue

func _on_show(screen_path:Array, shown:bool):
	show_node(screen_path, self, shown)

func _on_at(screen_path:Array, pos):
	pos_node_at(screen_path, self, pos)

func _on_with(screen_path:Array, type:String, value):
	if type == "scale":
		scale_node(screen_path, self, value)

	if type == "rotate":
		rotate_node(screen_path, self, value)