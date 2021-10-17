extends "ebbcode_parser.gd"
# RenPy Markup Parser
# It has one difference from original Ren'Py markup:
# for values we use '<','>' instead of '[' and ']'
# Adds support for :emojis:
# For emojis you need to install emojis-for-godot

func parse(text:String, editor:=false, variables:={}) -> String:
	text = convert_renpy_markup(text)
	
  # run base.parse
	return .parse(text, editor, variables)

func convert_renpy_markup(text:String) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	re.compile("(?<!\\[)\\[([\\w.]+)\\]")# Convert compatible variable inclusion
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "<" + result.get_string(1) + ">")
	text = output
	
	re.compile("(?<!\\{)\\{(\\/{0,1})a(?:(=[^\\}]+)\\}|\\})")# match unescaped "{a=" and "{/a}"
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[" + result.get_string(1) + "url" + result.get_string(2) + "]"
			output = regex_replace(result, output, replacement)
	text = output
	
	re.compile("(?<!\\{)\\{img=([^\\}]+)\\}")# match unescaped "{img=<path>}"
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]" + result.get_string(1) + "[/img]"
			output = regex_replace(result, output, replacement)
	text = output
	
	re.compile("(?:(?<!\\{)\\{[^\\{\\}]+)(\\})")# math "}" part of a valid tag
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "]", 1)
	text = output
	
	re.compile("(?<!\\{)\\{(?!\\{)")# match unescaped "{"
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "[")
	text = output
	
	re.compile("([\\{]+)")# match escaped braces "{{" transform them into "{"
	for result in re.search_all(text):
		if result.get_string():
			output = regex_replace(result, output, "{")
	text = output

	return text
