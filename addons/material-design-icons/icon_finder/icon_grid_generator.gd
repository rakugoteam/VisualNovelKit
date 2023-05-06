tool
extends EditorScript

var grid_bound := 0.9
var grid_x := 990 
var button_x := 36

const font_file := preload("../fonts/24.tres")
var MaterialIcons := preload("../icons/icons.gd").new()
var font := DynamicFont.new()

func _run():
	font = font_file
	var i := 1.0
	var p: = 0.0
	var size := float(MaterialIcons.icons.size())
	
	var grid := GridContainer.new()
	grid.name = "IconsGrid"
	grid.rect_size.x = grid_x

	for icon in MaterialIcons.icons.keys():
		var button = Button.new()
		button.clip_text = false
		button.name = icon
		button.set("custom_fonts/font", font)
		button.text = MaterialIcons.get_icon_char(icon)
		grid.add_child(button)
		button.owner = grid

		if p < int(i/size*100):
			p = int(i/size*100)
			print("loaded icons: ", p, "%")

		i += 1

	grid.columns = int((grid.rect_size.x / button_x)*grid_bound)

	var scene = PackedScene.new()
	var result = scene.pack(grid)

	if result == OK:
		var path := "res://addons/material-design-icons/icon_finder/IconsGrid.tscn"
		var error = ResourceSaver.save(path, scene)
		if error != OK:
				push_error("An error occurred while saving the scene to disk.")
				return
		print("IconsGrid saved")



