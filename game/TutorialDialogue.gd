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
			pass

		"showing":
			pass

		"jumping":
			pass
	
	end_event()

func script_tut():
	start_event("script_tut")

	say(null, "Choose Scripting Tutorial")
	var begin_from = menu([
		"Creating Dialogue",
		"Say", "Ask", "Menu",
		"Notify", "Characters",
		"Using Global Variables"
	])

	show("code")



	end_event()
