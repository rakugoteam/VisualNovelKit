extends Dialogue

func default_event():
	start_event("default_event")

	say(null, "Start of the default_event of the Second Dialogue of the Second scene.")
	step()
	
	say(null, "Continuing on that path.")
	step()

	say(null, "Again, and again.")
	step()
	
	end_event()
