tool
extends "EBBCodeParser.gd"
# now is added as autoload singleton : "MarkdownParser"

# Markdown Parser
# With support for <values> and :emojis:
# For emojis you need to install emojis-for-godot

func parse(text:String, headers_fonts:Array, variables:Dictionary) -> String:
	var output = "" + text

	# prints("markdown_parser run with variables:", variables)
	if !variables.empty():
		output = replace_variables(output, variables)
	
	# prints("emojis_gd:", emojis_gd)
	if emojis_gd:
		output = emojis_gd.parse_emojis(output)

	if icons_gd:
		output = parse_icons(output)

	# Parse headers
	if !headers_fonts.empty():
		output = parse_headers(output, headers_fonts)

	output = convert_markdown(output)
	return output

func convert_markdown(text:String) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	# ![](path/to/img)
	re.compile("!\\[\\]\\((.*?)\\)")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]%s[/img]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output

	# ![height x width](path/to/img)
	re.compile("!\\[(\\d+)x(\\d+)\\]\\((.*?)\\)")
	for result in re.search_all(text):
		if result.get_string():
			var height = result.get_string(1)
			var width = result.get_string(2)
			var path = result.get_string(3)
			replacement = "[img=%sx%s]%s[/img]" % [height, width, path]
			output = regex_replace(result, output, replacement)
	text = output

	# https://www.example.com
	re.compile("([=\\[\\]\\(]?)(\\w+:\\/\\/[A-Za-z0-9\\.\\-\\_\\@\\/]+)([\\]\\[\\)]?)")
	for result in re.search_all(text):
		if result.get_string():
			if !result.get_string(1).empty():
				continue
			if !result.get_string(3).empty():
				continue

			replacement = "[url]%s[/url]" % result.get_string(2)
			output = regex_replace(result, output, replacement)
	text = output

	# [link](path/to/file.md)
	re.compile("(\\]?)\\[(.+)\\]\\(([A-Za-z0-9\\.-_@\\/]+)\\)")
	for result in re.search_all(text):
		if result.get_string():
			if !result.get_string(1).empty():
				continue
			var _text = result.get_string(2)
			var url = result.get_string(3)
			replacement = "[url=%s]%s[/url]" % [url, _text]
			output = regex_replace(result, output, replacement)
	text = output

	# **bold**
	re.compile("\\*\\*(.*?)\\*\\*")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[b]%s[/b]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output
	
	# *italic*
	re.compile("\\*(.*?)\\*")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[i]%s[/i]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output

	# ~~strike through~~
	re.compile("~~(.*?)~~")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[s]%s[/s]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output

	# `code`
	re.compile("`{1,3}(.*?)`{1,3}")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[code]%s[/code]" % result.get_string(1)
			output = regex_replace(result, output, replacement)
	text = output

	# @tabel=2 {
	# | cell1 | cell2 |
	# }
	re.compile("@table=([0-9]+)\\s*\\{\\s*((\\|.+)\n)+\\}")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[table=%s]" % result.get_string(1)
			# cell 1 | cell 2
			var r = result.get_string()
			var lines = r.split("\n")
			for line in lines:
				if line.begins_with("|"):
					var cells : Array = line.split("|", false)
					for cell in cells:
						replacement += "[cell]%s[/cell]" % cell
					replacement += "\n"
			replacement += "[/table]"
			output = regex_replace(result, output, replacement)
	text = output

	# @color=red { text }
	re.compile("@color=([a-z]+)\\s*\\{\\s*([^\\}]+)\\s*\\}")
	for result in re.search_all(text):
		if result.get_string():
			var color = result.get_string(1)
			var _text = result.get_string(2)
			replacement = "[color=%s]%s[/color]" % [color, _text]
			output = regex_replace(result, output, replacement)
	text = output

	# @color=#ffe820 { text }
	re.compile("@color=(#[0-9a-f]{6})\\s*\\{\\s*([^\\}]+)\\s*\\}")
	for result in re.search_all(text):
		if result.get_string():
			var color = result.get_string(1)
			var _text = result.get_string(2)
			replacement = "[color=%s]%s[/color]" % [color, _text]
			output = regex_replace(result, output, replacement)
	text = output

	# @center { text }
	output = parse_keyword(text, "center", "center")
	text = output

	# @u { text }
	output = parse_keyword(text, "u", "u")
	text = output

	# @right { text }
	output = parse_keyword(text, "right", "right")
	text = output

	# @fill { text }
	output = parse_keyword(text, "fill", "fill")
	text = output

	# @justified { text }
	output = parse_keyword(text, "justified", "fill")
	text = output

	# @indent { text }
	output = parse_keyword(text, "indent", "indent")
	text = output

	# @tab { text }
	output = parse_keyword(text, "tab", "indent")
	text = output

	# @wave amp=50 freq=2{ text }
	output = parse_effect(text, "wave", ["amp", "freq"])
	text = output

	# @tornado radius=5 freq=2{ text }
	output = parse_effect(text, "tornado", ["radius", "freq"])
	text = output

	# @shake rate=5 level=10{ text }
	output = parse_effect(text, "shake", ["rate", "level"])
	text = output

	# @fade start=4 length=14{ text }
	output = parse_effect(text, "fade", ["start", "length"])
	text = output

	# @rainbow freq=0.2 sat=10 val=20{ text }
	output = parse_effect(text, "rainbow", ["freq", "sat", "val"])
	text = output

	return text

func parse_effect(text:String, effect:String, args:Array) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	# @effect args { text }
	# where args: arg_name=arg_value, arg_name=arg_value
	re.compile("@%s([\\s\\w=0-9\\.]+)\\s*{(.+)}" % effect)
	for result in re.search_all(text):
		if result.get_string():
			var _args = result.get_string(1)
			var _text = result.get_string(2)
			replacement = "[%s %s]%s[/%s]" % [effect, _args, _text, effect]
			output = regex_replace(result, output, replacement)
	text = output

	# @effect val1,val2 { text }
	re.compile("@%s\\s([0-9\\.\\,\\s]+)\\s*{(.+)}" % effect)
	for result in re.search_all(text):
		if result.get_string():
			var _values = result.get_string(1)
			_values = _values.replace(" ", "")
			_values = _values.split(",", false)
			var _text = result.get_string(2)
			var _args = ""
			for i in range(0, _values.size()):
				_args += "%s=%s " % [args[i], _values[i]]
			replacement = "[%s %s]%s[/%s]" % [effect, _args, _text, effect]
			output = regex_replace(result, output, replacement)
	text = output
	
	return text


func parse_keyword(text:String, keyword:String, tag:String) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""

	# @keyword {text}
	re.compile("@%s\\s*{(.+)}" % keyword)
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[%s]%s[/%s]" % [tag, result.get_string(1), tag]
			output = regex_replace(result, output, replacement)
	text = output

	return text

func parse_headers(text:String, headers_fonts:=[]) -> String:
	var headers_count = headers_fonts.size()

	if headers_count == 0:
		return text

	var re = RegEx.new()
	var output = "" + text

	re.compile("(#+)\\s+(.+)\n")
	for result in re.search_all(text):
		if result.get_string():
			var header_level = headers_count - result.get_string(1).length()
			header_level = clamp(header_level, 0, headers_count)
			var header_text = result.get_string(2)
			var header_font = headers_fonts[header_level]
			var replacement = "[font=%s]%s[/font]\n" % [header_font, header_text]
			output = regex_replace(result, output, replacement)
	
	return output
