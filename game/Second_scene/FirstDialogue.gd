extends Dialogue


func _ready():
	pass # Replace with function body.

func default_event():
	start_event("default_event")
	
	say(null, "Start of the default_event of the First Dialogue of the Second scene.")
	step()
	
	say(null, "Still in that damn event.")
	step()
	
	say(null, "Again.")
	step()
	
	say(null, "Starting the Second Dialogue.")
	step()
	
	jump("", "Second", "")
	
	end_event()
