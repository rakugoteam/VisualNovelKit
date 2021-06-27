extends Dialogue

func this_dialogue():
	start_event("this_dialogue")
	say(null, "This is Tutorial/Showcase Demo of Rakugo")
	var begin_from = menu([
		["Scripting Dialogue Tutorial", "scripting"],
		["Showing/Hide Character", "showing"],
		["Jumping Between Scenes/Dialogues", "jumping"],
		["More to Come", "more", {"disabled":true}]
	])

	match begin_from:
		"scripting":
			start("script_tut")

		"showing":
			pass

		"jumping":
			pass
	
	end_event()

func script_tut():
	start_event("script_tut")
