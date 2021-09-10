tool
extends EditorScript

var grid := GridContainer.new()
var file := File.new()
var emojis = preload("../emojis/emojis.gd").new()

func _run():
	var i := 1.0
	var p: = 0.0
	var size := float(emojis.emojis.size())

	for e in emojis.emojis.keys():
		var id = emojis.emojis[e]
		var png = emojis.get_path_to_emoji(id, 36)
		if not file.file_exists(png):
			continue
			
		var b := Button.new()
		b.name = e
		b.icon = load(png)
		b.connect("pressed", self, "on_emoji_clicked", [b])
		grid.add_child(b)
		b.owner = grid

		if p < int(i/size*100):
			p = int(i/size*100)
			print("loaded icons: ", p, "%")

		i += 1
	
	var scene = PackedScene.new()
	var result = scene.pack(grid)

	if result == OK:
		var path := "res://addons/Rakugo/tools/emojis_panel/EmojiGrid.tscn"
		var error = ResourceSaver.save(path, scene)
		
		if error != OK:
				push_error("An error occurred while saving the scene to disk.")
				return

		print("EmojisGrid saved")


