extends Dialogue

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
			say(null, "First, the crate Dialogue Node")
			show("screenshot create_dialogue")
			step()

			say(null, "Change it name")
			# show(screen_shot_of_this)
			step()

			say(null, "Choose Extend script")
			# show(screen_shot_of_this)
			step()

			say(null, "Now you can add code like this to crate dialogue")
			show("code dialogue")
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
			jump("Tutorial", "Dialogue", "intro")

	step()
	hide("code")
	start("script_tut")

	end_event()