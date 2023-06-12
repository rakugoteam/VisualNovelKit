tool
extends EditorPlugin

func _enter_tree():
	if !ProjectSettings.has_setting("markup_text_editor"):
		ProjectSettings.set_setting(
			"addons/advanced_text/markup", 
			"markdown"
		)

	ProjectSettings.set_order(
		"addons/advanced_text/markup", 0
	)
	ProjectSettings.add_property_info({
		"name": "addons/advanced_text/markup",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "markdown,renpy,bbcode"
	})

	if !ProjectSettings.has_setting("addons/advanced_text/default_vars"):
		ProjectSettings.set_setting(
			"addons/advanced_text/default_vars",
			JSON.print({
			"test_setting": "variable from project settings" 
			}, "\t"
		))

	ProjectSettings.add_property_info({
		"name": "addons/advanced_text/default_vars",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_MULTILINE_TEXT,
		"hint_string": ""
	})

	# loads all parser onces
	var parsers_dir := "res://addons/advanced-text/parsers/" 
	add_autoload_singleton("EBBCodeParser",  parsers_dir + "EBBCodeParser.gd")
	add_autoload_singleton("MarkdownParser", parsers_dir + "MarkdownParser.gd")
	add_autoload_singleton("RenpyParser", 	parsers_dir + "RenpyParser.gd")

func _exit_tree():
	ProjectSettings.set_setting("addons/advanced_text/markup", null)
	ProjectSettings.set_setting("addons/advanced_text/default_vars", null)

	# unloaded all parsers
	remove_autoload_singleton("EBBCodeParser")
	remove_autoload_singleton("MarkdownParser")
	remove_autoload_singleton("RenpyParser")

