tool
extends Node
# now is added as autoload singleton : "EBBCodeParser"

# Extended BBCode Parser
# Adds support for <values> and :emojis:
# For emojis you need to install emojis-for-godot

var EmojisImport
var emojis_gd = null

var IconsImport
var icons_gd = null
var icons_font := ""

func _init():
	EmojisImport = preload("../emojis_import.gd")
	EmojisImport = EmojisImport.new()
	if EmojisImport.is_plugin_enabled():
		emojis_gd = EmojisImport.get_emojis()
	else:
		EmojisImport.free()
	
	IconsImport = preload("../material_icons_import.gd")
	IconsImport = IconsImport.new()
	if IconsImport.is_plugin_enabled():
		icons_gd = IconsImport.get_icons()
		icons_font = IconsImport.mi_font_path
	else:
		IconsImport.free()

func parse(text:String, headers_fonts:Array, variables:Dictionary) -> String:
	var output = "" + text

	# prints("bbcode_parser run with variables:", variables)
	if !variables.empty():
		output = replace_variables(output, variables)

	# Parse headers
	if !headers_fonts.empty():
		output = parse_headers(output, headers_fonts)

	# prints("emojis_gd:", emojis_gd)
	if emojis_gd:
		output = emojis_gd.parse_emojis(output)
			
	if icons_gd:
		output = parse_icons(output)
	return output

func replace_variables(text:String, variables:Dictionary, placeholder := "<_>") -> String:
	var output = "" + text

	for k in variables.keys():
		if variables[k] is Dictionary:
			output = parse_variable(output, placeholder, k, variables[k])

		if variables[k] is Array:
			output = parse_variable(output, placeholder, k, variables[k])

		if variables[k] is String:
			output = parse_variable(output, placeholder, k, variables[k])

		if variables[k] is Color:
			var var_text = placeholder.replace("_", k)
			output = output.replace(var_text, "#"+variables[k].to_html(false))
		
		if variables[k] is Resource:
			var var_text = placeholder.replace("_", k)
			output = output.replace(var_text, variables[k].get_path())

	output = output.format(variables, placeholder)

	return output

func parse_variable(text:String, placeholder:String, variable:String, value) -> String:
	var re = RegEx.new()
	var output = "" + text

	var regex = placeholder.replace("[", "\\[")
	regex = regex.replace("]", "\\]")
	regex = regex.replace("(", "\\(")
	regex = regex.replace(")", "\\)")
	regex = regex.replace("_", "%s([\\.A-Z_a-z\\[0-9\\]]*?)" % variable)

	re.compile(regex)
	for result in re.search_all(text):
		if result.get_string(1):
			# check if result is key in dictionary
			if "." in result.get_string(1):
				var parts = result.get_string(1).split(".")
				var key = parts[1]
				var _value = value[key]

				if parts.size() > 1:
					for i in range(2, parts.size()):
						key = parts[i]
						_value = _value[key]
					
				return output.replace(result.get_string(), _value)
			
			# check if result is index in array
			if "[" in result.get_string(1):
				if "]" in result.get_string(1):
					var parts = result.get_string(1).split("[")
					var index = int(parts[1].split("]")[0])
					var _value = value[index]

					if parts.size() > 1:
						for i in range(2, parts.size()):
							index = parts[i]
							_value = _value[index]
					
					return output.replace(result.get_string(), _value)

	return output

func regex_replace(result:RegExMatch, output:String, replacement:String, string_to_replace=0) -> String:
	var offset = output.length() - result.subject.length()
	var left = output.left(result.get_start(string_to_replace) + offset)
	var right = output.right(result.get_end(string_to_replace) + offset)
	return left + replacement + right

func parse_headers(text:String, headers_fonts:Array) -> String:
	var headers_count = headers_fonts.size()
	
	if headers_count == 0:
		return text
	
	var re = RegEx.new()
	var output = "" + text

	re.compile("\\[h([1-4])\\](.+)\\[/h[1-4]\\]")
	for result in re.search_all(text):
		if result.get_string():
			var header_level = headers_count - int(result.get_string(1))
			header_level = clamp(header_level, 0, headers_count - 1)
			var header_text = result.get_string(2)
			var header_font = headers_fonts[header_level]
			var replacement = "[font=%s]%s[/font]" % [header_font, header_text]
			output = regex_replace(result, output, replacement)
	
	return output

func parse_icons(text:String):
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	# [icon=icon-name]
	re.compile("\\[icon=([\\w\\d-]+)\\]")
	for result in re.search_all(text):
		if result.get_string():
			var icon = result.get_string(1)
			replacement = _parse_icon(icon)
		output = regex_replace(result, output, replacement)

	# [icon=icon-name,size]
	re.compile("\\[icon=([\\w\\d-]+)\\,\\s*([0-9]+)\\]")
	for result in re.search_all(text):
		if result.get_string():
			var icon = result.get_string(1)
			var size = result.get_string(2)
			replacement = _parse_icon(icon, size)
			output = regex_replace(result, output, replacement)
	
	return output

func _parse_icon(icon_name:String, size:="24") -> String:
	var ch = icons_gd.get_icon_char(icon_name)
	var font = icons_font % size
	return "[font=%s]%s[/font]" %  [font, ch]
