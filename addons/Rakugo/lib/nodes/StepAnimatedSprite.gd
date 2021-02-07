extends AnimatedSprite
class_name StepAnimatedSprite

export var animated_sprite_id : String = ""
export var block_step_when_playing : bool = false
export var step_when_finished : bool = false
export(int, "Pause", "Continue", "Stop", "Restart", "None") var behavior_on_step : int = 0;
export(int, "Pause", "Stop", "Unblock", "None") var behavior_on_blocked_step : int = 3;


func _ready():
	self.connect('animation_finished', self, "__on_animation_finished")
	print(self)


func _store(store):
	if animated_sprite_id:
		var pack = [self.playing, self.animation, self.frame]
		store.set("animated_sprite_%s" % animated_sprite_id, pack)


func _restore(store):
	if animated_sprite_id:
		var pack = store.get("animated_sprite_%s" % animated_sprite_id)
		if pack is Array and pack.size() == 3:
			self.stop()
			self.animation = pack[1]
			self.frame = pack[2]
			if pack[0]:
				self.play()
			_step()


func _step():
	match behavior_on_step:
		0:
			self.stop()
		1:
			self.play()
		2:
			self.frame = 0
			self.stop()
		3:
			self.frame = 0
			self.play()
		4:
			pass

func _blocked_step():
	match behavior_on_step:
		0:
			self.stop()
		1:
			self.frame = 0
			self.stop()
		2:
			Rakugo.StepBlocker.unblock('animated_sprite_%s_%s' % [animated_sprite_id, self.name])
		3:
			pass


func play(anim:String ='', backward:bool = false):
	if block_step_when_playing:
		Rakugo.StepBlocker.block('animated_sprite_%s_%s' % [animated_sprite_id, self.name])
	.play(anim, backward)


func stop():
	.stop()
	if block_step_when_playing:
		Rakugo.StepBlocker.unblock('animated_sprite_%s_%s' % [animated_sprite_id, self.name])


func __on_animation_finished():
	if not self.is_looping():
		if block_step_when_playing:
			Rakugo.StepBlocker.unblock('animated_sprite_%s_%s' % [animated_sprite_id, self.name])
		if step_when_finished:
			Rakugo.story_step()


func is_looping():
	return self.get_sprite_frames().get_animation_loop(self.animation)

