tool
class_name Emojis, "../icon.png"

var path_here = "res://addons/emojis-for-godot/emojis/"
var json_path = path_here + "emojis.json"
var emojis_path = path_here + "%dx%d/%s.tres"
var emojis:Dictionary = {} setget dummy_set

func _init():
	var content = get_file_content(json_path)
	var emojis_list = parse_json(content)
	init_emoji_dictionaries(emojis_list)

func get_file_content(path:String) -> String:
	var file = File.new()
	var error = file.open(path, file.READ)
	var content = ""

	if error == OK:
		content = file.get_as_text()
		file.close()
		
	return content

func init_emoji_dictionaries(list:Array):
	self.emojis = {}

	for group in list:
		for emoji in group.emojis:
			var name = emoji.shortname
			name = name.replace(":", "")
			name = name.replace("regional_indicator_", "")
			self.emojis[name] = emoji.hex

func get_path_to_emoji(id:String, size:int = 16) -> String:
	if id in emojis:
		return emojis_path % [size, size, emojis[id]]

	push_warning("Emoji %dx%d/%s not found." % [size, size, id])
	return ""

func get_emoji_bbcode(id:String, size:int = 16) -> String:
	var path = get_path_to_emoji(id, size)
	
	if path:
		return "[img]%s[/img]" % path

	return ""

func dummy_set(_value):
	pass
