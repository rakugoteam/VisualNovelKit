extends Object
class_name ScreenBase

# It provides the basic functionality for all Screens Nodes.
# is not a Node itself, but a collection of methods used by all Screens Nodes.

func array_to_vector(array:Array, acceptable_sizes := [2, 3]):
	if array.size() == 2 and 2 in acceptable_sizes:
		return Vector2(array[0], array[1])
	
	if array.size() == 3 and 3 in acceptable_sizes:
		return Vector2(array[0], array[1])

	return null

func calculate_pos(any:String):
	if " " in any:
		var args = any.split(" ")
		# check if args are numbers
		
		for arg in args:
			if not arg.is_valid_float():
				# return keywords_to_pos(args)
				push_error("Invalid position value: " + any)
		
		var pos = array_to_vector(args)
		if pos == null:
			push_error("Invalid position value: " + any)
			return
		
		return pos

func calculate_scale(any:String):
	if any.is_valid_float():
		return any.to_float()

	if " " in any:
		var args = any.split(" ")
		# check if args are numbers
		
		for arg in args:
			if not arg.is_valid_float():
				push_error("Invalid scale value: " + any)
				return

		var scale = array_to_vector(args)
		if scale == null:
			push_error("Invalid scale value: " + any)
			return
		
		return scale

func calculate_rot(any:String):
	if any.is_valid_float():
		return any.to_float()

	if " " in any:
		var args = any.split(" ")
		# check if args are numbers
		
		for arg in args:
			if not arg.is_valid_float():
				push_error("Invalid rotation value: " + any)
				return

		var rot = array_to_vector(args, [3])
		if rot == null:
			push_error("Invalid rotation value: " + any
				+ ", must be a number or a vector with 3 values.")
			return
		
		return rot

func any_to_args(op_type: String, any:String):
	match op_type:
		"pos":
			return calculate_pos(any)
			
		"scale":
			return calculate_scale(any)
		
		"rot":
			return calculate_rot(any)

func get_nodes_from_path(screen_path:Array, node:Node) -> Array:
	# returns an array of nodes from the screen_path
	# prints("get_nodes_from_path", screen_path, node)
	
	var nodes = [node]
	screen_path.pop_front()
	while screen_path.size() > 0:
		var n = screen_path.pop_front()
		node = node.get_node(n)
		if node == null:
			push_error("None Node2D or Screen2D named " + n + " found.")
			return nodes
		
		nodes.append(node)
	
	return nodes

func show_node(screen_path:Array, node:Node, shown:bool):
	# show all nodes in the screen_path if shown is true
	# but if shown is false, hide only last node in the screen_path
	var nodes = get_nodes_from_path(screen_path, node)
	# prints("show_node", shown, nodes)

	if not shown:
		nodes[-1].hide()
		return
	
	for n in nodes[-2].get_children():
		n.hide()

	for n in nodes:
		n.show()

