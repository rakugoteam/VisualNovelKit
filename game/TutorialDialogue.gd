extends Dialogue

func intro():
	start_event("intro")
	hide("code")
	say(null, 
		"This is Tutorial/Showcase Demo of Rakugo\n"
		+ "Choose what you want to see/lean about."
	)
	var begin_from = menu([
		["Scripting Dialogue Tutorial", "scripting"],
		["Markups"],
		["Showing/Hide Character", "showing"],
		["Jumping Between Scenes/Dialogues", "jumping"],
		["More to Come", "more", {"disabled":true}]
	])

	match begin_from:
		"scripting":
			start("script_tut")

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

func script_tut():
	start_event("script_tut")

	say(null, "Choose Scripting Tutorial")
	var script = menu([
		"Creating Dialogue",
		"Say", "Ask", "Menu",
		"Notify", "Characters",
		"Using Global Variables",
		"Go Back"
	])
	
	match script:
		"Creating Dialogue":
			show("code")
			pass

		"Say":
			show("code")
			pass

		"Ask":
			show("code")
			pass

		"Menu":
			show("code")
			pass

		"Notify":
			show("code")
			pass

		"Characters":
			show("code")
			pass
			
		"Using Global Variables":
			show("code")
			pass

		"Go Back":
			start("intro")

	end_event()
