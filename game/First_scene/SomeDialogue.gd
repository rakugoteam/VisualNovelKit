extends Dialogue

var path_choice = ''

func some_event():
	start_event("some_event")


	say(null, "Show 'rect {color=red}red{/color}'", {"typing":true})
	show("rect red")
	step()
	
	say(null, "Show 'rect {color=blue}blue{/color}'", {"typing":true})
	show("rect blue")
	notify("Some notification that is really important to show")
	step()
	
	say(null, "Hide 'rect red'", {"typing":true})
	hide("rect red")
	step()
	
	say(null, "Little test of the choice menu", {"typing":true})
	var choice = menu([["Choice 1", 1, {}], ["Choice 2", 2, {'visible':true}],["Choice 3", 3, {'visible':false}]])
	step()
	
	say(null, "You chose '%s' (not saved, this will not display correctly after loading or rolling), image tag test :{img=res://addons/Rakugo/emojis/16x16/1f1e6.tres}" % str(choice))
	step()
	
	say(null, "Show 'rect'(inexistant), emoji tag test {:1f1e6:}")
	show("rect")
	step()
	
	say(null, "Hide 'rect'")
	hide("rect")
	step()
	
	say(null, "Show 'rect orange'")
	show("rect orange")
	step()
	
	say(null, "Show 'rect orange 1'")
	show("rect orange 1")
	step()
	
	
	say(null, "Select a path. This an example of a path choosing without using menu()")
	show("rect red")
	show("pathchoice")
	step()
	
	if cond(path_choice == 'green'):
		say(null, "Green path chosen, yeah fuck blue")
		show("rect green")
		hide("pathchoice")
		step()
		
		say(null, "I confirm {color=[path_color]}[path_color]{/color} chosen")
		step()
	elif cond(path_choice == 'blue'):
		say(null, "Blue FTW, Green is for tards, amiright")
		show("rect blue")
		hide("pathchoice")
		step()
		
		say(null, "I confirm {color=[path_color]}[path_color]{/color} chosen")
		step()
	else:
		say(null, "Haha you did the right thing not picking of those inferior colors, ")
		hide("pathchoice")
		step()
		
	say(null, "Merging back paths.")
	step()
	
	jump("Second", "First", "")
	
	end_event()


func _on_green_path_chosen():
	self.path_choice = "green"
	Rakugo.store.path_color = "green"
	Rakugo.story_step()


func _on_blue_path_chosen():
	self.path_choice = "blue"
	Rakugo.store.path_color = "blue"
	Rakugo.story_step()
