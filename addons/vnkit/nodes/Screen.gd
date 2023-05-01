extends Control
class_name Screen

## used to identify the screen alternative to using the name of the node
## useful when you spawn a screen from a script in runtime
export var screen_name := ""
export var hide_on_start := false
var _base : ScreenBase

func _ready():
	visible = !hide_on_start
	_base = ScreenBase.new()
	Screens.connect("show", self, "_on_show")
	Screens.connect("pos", self, "_on_pos")
	Screens.connect("scale", self, "_on_scale")
	Screens.connect("rot", self, "_on_rot")

	func _on_pos(screen_path:Array, pos):
		if screen_path[0] in [name, screen_name]:
			var nodes = get_nodes_from_path(screen_path, node)
			var _pos = calculate_pos(pos)
	
			nodes.back().rect_position = _pos
	
	func _on_scale(screen_path:Array, value):
		if screen_path[0] in [name, screen_name]:
			var nodes = get_nodes_from_path(screen_path, node)
			var _scale = calculate_scale(scale)
	
			if _scale is float:
				_scale = Vector2(_scale, _scale)
	
			nodes.back().rect_scale = _scale
	
	func _on_rot(screen_path:Array, value):
		if screen_path[0] in [name, screen_name]:
			var nodes = get_nodes_from_path(screen_path, node)
			var _rot = calculate_rot(rot)
			
			nodes.back().rect_rotation = _rot
