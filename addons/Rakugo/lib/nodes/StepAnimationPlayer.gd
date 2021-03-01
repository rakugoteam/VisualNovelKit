extends AnimationPlayer
class_name StepAnimationPlayer

export var animation_player_id : String = ""
export var block_step_when_playing : bool = false 
export var step_when_finished : bool = false
export(int, "Pause", "Continue", "Stop", "Restart", "None") var behavior_on_step : int = 0;
export(int, "Pause", "Stop", "Unblock", "None") var behavior_on_blocked_step : int = 3;


func _ready():
	self.connect("animation_started", self, "__on_animation_started");
	self.connect("animation_changed", self, "__on_animation_changed");
	self.connect("animation_finished", self, "__on_animation_finished");


func _store(store):
	if animation_player_id:
		var pack = [is_playing(), assigned_animation, 0, 1, get_queue()]
		if assigned_animation:
			pack[2] = current_animation_position
		if is_playing():
			pack[3] = get_playing_speed()
		
		store.set("animation_player_%s" % animation_player_id, pack)


func _restore(store):
	if animation_player_id:
		var pack = store.get("animation_player_%s" % animation_player_id)
		if pack is Array and pack.size() == 5:
			self.stop(true)
			self.seek(0, true)
			self.clear_queue()
			if pack[1]:
				self.set_assigned_animation(pack[1])
				self.seek(pack[2], true)
			for q in pack[4]:
				self.queue(q)
			if pack[0]:
				if pack[3] != 1:
					self.play('', -1, pack[3] / self.get_speed_scale())
				else:
					self.play()


func _step():
	match behavior_on_step:
		0:
			self.stop(false)
		1:
			if assigned_animation:
				self.play()
		2:
			self.stop(true)
		3:
			if assigned_animation:
				self.seek(0)
				self.play()
		4:
			pass

func _blocked_step():
	match behavior_on_step:
		0:
			self.stop(false)
		1:
			self.stop(true)
		2:
			Rakugo.StepBlocker.unblock('animation_player_%s_%s' % [animation_player_id, self.name])
		3:
			pass


func stop(reset:bool = true):
	.stop(reset)
	if block_step_when_playing:
		Rakugo.StepBlocker.unblock('animation_player_%s_%s' % [animation_player_id, self.name])


func __on_animation_started(_anim):
	if block_step_when_playing:
		Rakugo.StepBlocker.block('animation_player_%s_%s' % [animation_player_id, self.name])

func __on_animation_changed(_old_anim, _new_anim):
	if block_step_when_playing:
		Rakugo.StepBlocker.unblock('animation_player_%s_%s' % [animation_player_id, self.name])

func __on_animation_finished(_anim):
	if block_step_when_playing:
		Rakugo.StepBlocker.unblock('animation_player_%s_%s' % [animation_player_id, self.name])
		if step_when_finished:
			Rakugo.story_step()
