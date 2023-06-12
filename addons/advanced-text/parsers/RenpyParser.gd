tool
extends "EBBCodeParser.gd"
# now is added as autoload singleton : "RenpyParser"

# RenPy Markup Parser
# it used '<' and '>' for values instead of '[' and ']'
# Adds support for :emojis:
# For emojis you need to install emojis-for-godot

func parse(text:String, headers_fonts:Array, variables:Dictionary) -> String:
	var output = ""	+ text
	if output.begins_with('"""\n'):
		var lines : Array = output.split('\n')
		lines.pop_at(0)
		if lines.back() == '"""':
			lines.pop_back()
		output = PoolStringArray(lines).join('\n')

	# prints("renpy_parser run with variables:", variables)
	if !variables.empty():
		# like in renpy - don't work with arrays indexing :(
		# output = replace_variables(output, variables, "[_]")
		output = replace_variables(output, variables, "<_>")

	output = convert_renpy_markup(output)

	# Parse headers
	if !headers_fonts.empty():
		output = parse_headers(output, headers_fonts)
		
	# prints("emojis_gd:", emojis_gd)
	if emojis_gd:
		output = emojis_gd.parse_emojis(output)

	if icons_gd:
		output = parse_icons(output)

	return output

func convert_renpy_markup(text:String) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	# match unescaped "{a=" and "{/a}"
	re.compile("(?<!\\{)\\{(\\/{0,1})a(?:(=[^\\}]+)\\}|\\})")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[%surl%s]" % [result.get_string(1), result.get_string(2)]
			output = regex_replace(result, output, replacement)
	text = output
	
	# match unescaped "{img=<path>}"
	re.compile("(?<!\\{)\\{img=([^\\}\\s]+)\\}")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]%s[/img]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output

	# match unescaped "{img=<path> size=<height>x<width>}"
	re.compile("(?<!\\{)\\{img=([^\\}\\s]+) size=([^\\}]+)\\}")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img=%s]%s[/img]" % [result.get_string(2), result.get_string(1)]
			output = regex_replace(result, output, replacement)
	
	# math "}" part of a valid tag
	re.compile("(?:(?<!\\{)\\{[^\\{\\}]+)(\\})")
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "]", 1)
	text = output
	
	# match unescaped "{"
	re.compile("(?<!\\{)\\{(?!\\{)")
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "[")
	text = output
	
	# match escaped braces "{{" transform them into "{"
	re.compile("([\\{]+)")
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "{")
	text = output

	return text
