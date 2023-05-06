tool
extends Object

# MI stands from Material Icons
# this file is similar to icons_import.gd
const mi_path := "res://addons/material-design-icons/icons/icons.gd"
const mi_plugin_path := "res://addons/material-design-icons/plugin.cfg"
const mi_panel := "res://addons/material-design-icons/icon_finder/IconFinder.tscn"
const mi_icon_path := "res://addons/material-design-icons/nodes/MaterialIcon.svg"
const mi_font_path := "res://addons/material-design-icons/fonts/%s.tres"

var f := File.new()
var _icons
var _plugin_enabled := false
var _warning_shown := false

func _init():
	if !_plugin_enabled:
		var plugins = ProjectSettings.get_setting("editor_plugins/enabled")
		_plugin_enabled =  mi_plugin_path in plugins

	if !_plugin_enabled && !_warning_shown:
		push_warning("icons-for-godot are not enabled")
		_warning_shown = true

func is_plugin_enabled() -> bool:
	return _plugin_enabled

func get_icons():
	if _icons:
		return _icons

	if !is_plugin_enabled():
		return null

	if f.file_exists(mi_path):
		_icons = load(mi_path)
		_icons = _icons.new()
		return _icons

	else:
		print("icons.gd not found")
		return null

func get_icons_panel() -> Node:
  if !is_plugin_enabled():
    return null

  var panel = load(mi_panel)
  return panel.instance()

func get_icon() -> Texture:
  if !is_plugin_enabled():
    return null

  var icon = load(mi_icon_path)
  return icon

