# this script adds "show", "hide", "pos", "scale", "rot" keywords to RakuScript
extends Node

signal show(screen, show)
signal pos(screen, pos)
signal scale(screen, scale)
signal rot(screen, rot)

func _ready():
	# regex for screen names with spaces
	var screen_regex = "([a-zA-Z0-9]+ ?)+"
	Rakugo.parser_add_regex_at_runtime("show", "^show (?<screen>%s)$" % screen_regex)
	Rakugo.parser_add_regex_at_runtime("hide", "^hide (?<screen>%s)$" % screen_regex)

	var any_regex = "(?<any>.+)"

	Rakugo.parser_add_regex_at_runtime("pos", "^(?<screen>%s) pos %s$" % [screen_regex, any_regex])

	Rakugo.parser_add_regex_at_runtime("scale", "^(?<screen>%s) scale %s$" % [screen_regex, any_regex])

	Rakugo.parser_add_regex_at_runtime("rot", "^(?<screen>%s) rot %s$" % [screen_regex, any_regex])

	Rakugo.connect("parser_unhandled_regex", self, "_on_parser_unhandled_regex")


func _on_parser_unhandled_regex(key:String, result:RegExMatch):
	if key in ["show", "hide", "pos", "scale", "rot"]:
		var screens = result.get_string("screen").split(" ")
		# prints("screen command:", key, "on path:", result.get_string("screen"), "->", screens)

		match(key):
			"show","hide":
				emit_signal("show", screens , key == "show")

			"pos":
				emit_signal("pos", screens, result.get_string("any"))

			"scale":
					emit_signal("scale", screens, result.get_string("any"))

			"rot":
					emit_signal("rot", screens, result.get_string("any"))