extends Dialogue

func tests():
	start_event("tests")
	show("dialogue")

	say(null, "testing [color=red]say()[/color] 0")
	step()

	say(null, "testing [color=red]say()[/color] 1")
	step()

	say(null, "testing [color=red]say()[/color] 2")
	step()

	say(null, "testing [color=red]say()[/color] try go back")
	step()

	say(null, "testing [color=red]if cond()[/color] 0")
	step()

	if cond(true):
		say(null, "if cond => [color=red]true[/color] 1a")
	else:
		say(null, "if cond => [color=red]false[/color] 1b")
	step()
	
	say(null, "testing [color=red]cond()[/color] try go back.")
	step()

	say(null, "testing [color=red]match cond()[/color] 2")
	var choice = menu([
		"Choice A", "Choice B"
	])

	match cond(choice):
		"Choice A":
			say(null, "match cond => [color=red]Choice A[/color] 3a")
		"Choice B":
			say(null, "match cond => [color=red]Choice B[/color] 3b")
	step()

	say(null, "testing [color=red]match cond()[/color] try to go back")




	end_event()