tool
extends EditorPlugin
var icon_search : WindowDialog
var menu_item := ["Find Material Icon", "popup_centered", Vector2(450, 400)]

func _enter_tree():
	icon_search = preload("icon_finder/IconFinder.tscn").instance()
	add_control_to_container(CONTAINER_TOOLBAR, icon_search)
	add_tool_menu_item(menu_item[0], icon_search, menu_item[1], menu_item[2])

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, icon_search)
