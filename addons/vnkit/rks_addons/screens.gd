# this script adds "show", "hide", "at" and "with" keywords to RKScript
extends Node

signal show(screen, show)
signal at(screen, pos)
signal with(screen, with_type, value)

func _ready():
	# regex for screen names with spaces
	var screen_regex = "([a-zA-Z0-9_]+ ?)+"
	Rakugo.parser_add_regex_at_runtime("show", "^show (?<screen>%s)" % screen_regex)
	Rakugo.parser_add_regex_at_runtime("hide", "^hide (?<screen>%s)" % screen_regex)

	# pos can be vector2, vector3 or keyword
	var pos_regex = "((?<x>[0-9]+) (?<y>[0-9]+)( (?<z>[0-9]+))?)|(?<pos>[a-zA-Z_]+)"
	Rakugo.parser_add_regex_at_runtime("at", "^at (?<screen>%s) (?<pos>%s)" % [screen_regex, pos_regex])

	# scale can be vector2 or vector3
	var scale_regex = "(?<x>[0-9]+) (?<y>[0-9]+)( (?<z>[0-9]+))?"
	# rotation can be one float or vector3
	var rotation_regex = "(?<x>[0-9]+)( (?<y>[0-9]+)( (?<z>[0-9]+))?)?"
	# "with" keyword can be used with "scale" or "rotation"
	var with_regex = "(scale (?<scale>%s))|(rotation (?<rotation>%s))" % [scale_regex, rotation_regex]
	Rakugo.parser_add_regex_at_runtime("with", "^with (?<screen>%s) (?<with>%s)" % [screen_regex, with_regex])

func _on_parser_unhandled_regex(key:String, result:RegExMatch):
	if key in ["show", "hide", "at", "with"]:
		var screen = result.get_string("screen").split(" ")

		match(key):
			"show","hide":
				emit_signal("show", screen , key == "show")

			"at":
				emit_signal("at", screen, result.get_string("pos"))

			"with":
				if result.get_string("with") == "scale":
					emit_signal("with", screen, "scale", result.get_string("scale"))

				if result.get_string("with") == "rotation":
					emit_signal("with", screen, "rotation", result.get_string("rotation"))