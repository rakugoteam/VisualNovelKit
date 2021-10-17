extends "ebbcode_parser.gd"
# Markdown Parser
# With support for <values> and :emojis:
# For emojis you need to install emojis-for-godot

func parse(text:String, editor:=false, variables:={}) -> String:
	text = convert_markdown(text)
	
  # run base.parse
	return .parse(text, editor, variables)

func convert_markdown(text:String) -> String:
	var re = RegEx.new()
	var output = "" + text
	var replacement = ""
	
	re.compile("!\u200B?\\[\u200B?\\]\\(([^\\(\\)\\[\\]]+)\\)")# ![](path/to/img)
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]" + result.get_string(1) + "[/img]"
			output = regex_replace(result, output, replacement)
	text = output

	# either plain "prot://url" and "[link](url)" and not "[img]url[\img]"
	re.compile("(\\[img\\][^\\[\\]]*\\[\\/img\\])|(?:(?:\\[([^\\]\\)]+)\\]\\(([a-zA-Z]+:\\/\\/[^\\)]+)\\))|([a-zA-Z]+:\\/\\/[^ \\[\\]]*[a-zA-Z0-9_]))")

	for result in re.search_all(text):
		# having anything in 1 meant it matched "[img]url[\img]"
		if result.get_string() and not result.get_string(1): 
			if result.get_string(4):
				replacement = "[url]" + result.get_string(4) + "[/url]"
			else:
				# That can can be the user erroneously writing "[b](url)[\b]" need to be pointed in the doc
				replacement = "[url=" + result.get_string(3) + "]" + result.get_string(2) + "[/url]"
			output = regex_replace(result, output, replacement)
	text = output

	re.compile("\\*\\*([^\\*]+)\\*\\*")# **bold**
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[b]" + result.get_string(1) + "[/b]"
			output = regex_replace(result, output, replacement)
	text = output
	
	re.compile("\\*([^\\*]+)\\*")# *italic*
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[i]" + result.get_string(1) + "[/i]"
			output = regex_replace(result, output, replacement)
	text = output

	re.compile("~~([^~]+)~~")# ~~strike through~~
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[s]" + result.get_string(1) + "[/s]"
			output = regex_replace(result, output, replacement)
	text = output

	re.compile("`([^`]+)`")# `code`
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[code]" + result.get_string(1) + "[/code]"
			output = regex_replace(result, output, replacement)
	text = output

	return text
