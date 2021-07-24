extends Dialogue

func intro():
	start_event("intro")
	hide("code")
	say(null, 
		"This is Tutorial/Showcase Demo of Rakugo\n"
		+ "Choose what you want to see/learn about."
	)
	var begin_from = menu([
		["Scripting Dialogue Tutorial", "scripting"],
		"Markups",
		["Showing/Hide Character", "showing"],
		["Jumping Between Scenes/Dialogues", "jumping"],
		["More to Come", "more", {"disabled":true}]
	])

	match begin_from:
		"scripting":
			$"../Scripting/Dialogue".start()

		"Markups":
			start("markups")

		"showing":
			pass

		"jumping":
			pass
	
	end_event()

func markups():
	start_event("markups")

	say(null, "Choose Scripting Tutorial")
	var markup = menu([
		"Markdown Example",
		"Ren`Py Example",
		"BBCode Example",
		"Go Back"
	])

	match markup:
		"Markdown Example":
			show("code")
			# show("rakugo_text")
			pass

		"Ren`Py Example":
			show("code")
			# show("rakugo_text")
			pass

		"BBCode Example":
			show("code")
			# show("rakugo_text")
			pass

		"Go Back":
			start("intro")

	end_event()


