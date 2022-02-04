extends RakugoTextLabel

var regex = RegEx.new()
var skip_typing = false

var delay = 0 
var punc_delay = 0

signal typing_effect_tick
signal typing_effect_started
signal typing_effect_ended

func _ready():
	regex.compile("[[:graph:]]")

func _blocked_step():
	end_typing_effect()


# now its called from DialoguePanel
func _on_say(_character, _text, _parameters):
	self.visible_characters = -1
	self.markup = _parameters.get("markup", "")
	self.rakugo_text = _text
	
	if not Rakugo.skipping and _parameters.get('typing'):
		if _parameters.get('typing_effect_delay'):
			delay = _parameters.get('typing_effect_delay')
		else:
			delay = float(Settings.get(SettingsList.typing_effect_delay))
		
		if _parameters.get('typing_effect_punctuation_factor'):
			punc_delay = _parameters.get('typing_effect_punctuation_factor')
		else:
			punc_delay = delay * float(Settings.get(SettingsList.typing_effect_punctuation_factor))
		start_typing_effect()


func start_typing_effect():
	$TypingTimer.start(delay)
	skip_typing = false
	self.visible_characters = 1
	Rakugo.StepBlocker.set_block('typing_effect', 1)
	emit_signal('typing_effect_started')


func end_typing_effect():
	$TypingTimer.stop()
	skip_typing = true
	self.visible_characters = -1
	Rakugo.StepBlocker.unblock('typing_effect')
	emit_signal('typing_effect_ended')


func _on_timer_tick():
	if is_visible_in_tree():
		if Rakugo.skipping or skip_typing:
			end_typing_effect()
		else:
			self.visible_characters += 1
			emit_signal('typing_effect_tick')
			if self.visible_characters < self.text.length():
				var ch = self.text[self.visible_characters]
				if regex.search(ch):
					if ch in ",;.!?":
						$TypingTimer.start(punc_delay)
					else:
						$TypingTimer.start(delay)
				else:
					_on_timer_tick()
			else:
				end_typing_effect()

