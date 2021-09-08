extends Node
class_name Dialogue, "res://addons/Rakugo/icons/dialogue.svg"

onready var _class_script_version = _get_dialogue_script_hash()
onready var _script_version = _get_script_hash()

export var default_starting_event = ""
export var auto_start = false
export var version_control = false

#Those are only used as analogues of arguments
var target = 0
var condition_stack = []

var event_stack = []#LIFO stack of elements [event_name, current_counter, target, condition_stack(FIFO stack)]

var thread:Thread
var step_semaphore:Semaphore
var return_lock:Semaphore

func _store(save):
	if Rakugo.current_dialogue == self:
		save.current_dialogue = self.name
		save.current_dialogue_event_stack = self.event_stack.duplicate(true)
		save.current_dialogue_script_version = _script_version
		save.dialogue_class_script_version = _class_script_version

func _restore(save):
	if save.current_dialogue == self.name:
		if check_for_version_error(save):
			return
		start_thread(save.current_dialogue_event_stack.duplicate(true))

func _step():
	if Rakugo.current_dialogue == self and is_running():
		if self.step_semaphore:
			self.step_semaphore.post()

func start(event_name=''):
	if event_name:
		start_thread([[event_name, 0, 0, []]])

	elif self.has_method(default_starting_event):
		start_thread([[default_starting_event, 0, 0, []]])

	else:
		push_error("Dialogue '%s' started without given event nor default event." % self.name)

## Dialogue life cycle state

enum State {
	READY,
	RUNNING,
	EXITING,
	ENDED,
	RESTARTING
}
var state:int = State.READY  setget ,get_state

func get_state():
	return state

func is_ready():
	return self.state == State.READY

func is_running():
	return self.state == State.RUNNING

func is_exiting():
	return self.state == State.EXITING

func is_ended():
	return self.state == State.ENDED
	
func is_restarting():
	return self.state == State.RESTARTING


## Thread life cycle

func start_thread(_event_stack):
	if not is_ready() and not is_ended():
		self.state = State.RESTARTING
		self.exit()
		thread.wait_to_finish()

	event_stack = _event_stack
	Rakugo.set_current_dialogue(self)
	thread = Thread.new()
	thread.start(self, "dialogue_loop")


func dialogue_loop(_a):
	self.state = State.RUNNING
	while is_running() and event_stack:
		var e = event_stack.pop_front()
		self.call_event(e[0], e[1], e[3])
		
	self.state = State.EXITING
	self.call_deferred('end_thread')

func end_thread():
	if is_exiting():
		self.state = State.ENDED
		thread.wait_to_finish()

		if Rakugo.current_dialogue == self:
			Rakugo.set_current_dialogue(null)

func exit():
	if is_running():
		self.state = State.EXITING

	if not is_ended():
		if step_semaphore:
			step_semaphore.post()

		if return_lock:
			return_lock.post()

## Events Flow control and Administration

func call_event(event, _target = 0, _condition_stack = []):
	if is_active():
		#Using class vars to make event methods argument less.
		self.target = _target
		self.condition_stack = _condition_stack.duplicate()
		self.call(event)

func start_event(event_name):
	if event_stack:
		event_stack[0][1] += 1# Disabling step counter in case of saving before returning

	if not is_active():
		event_stack.push_front([event_name, 0, INF, self.condition_stack])

	else:
		event_stack.push_front([event_name, 0, self.target, self.condition_stack])
		#Should be "get_stack()[1]['function']" instead of passing event_name, if get_stack() worked
	
	if is_active():
		Rakugo.History.log_event(self.name ,event_name)

func cond(condition):
	if not is_running():
		return false

	if is_active(true):
		event_stack[0][3].push_front(condition)
	
	else:
		condition = event_stack[0][3].pop_back()
	
	return condition

func step():
	if not step_semaphore:
		step_semaphore = Semaphore.new()

	if is_active():
		step_semaphore.wait()

	event_stack[0][1] += 1
	# Preventing a case of multiple post skipping steps
	step_semaphore = Semaphore.new()

func end_event():
	if is_running():
		event_stack.pop_front()

		if event_stack:
			# Realign step counter before returning
			event_stack[0][1] -= 1

func is_active(_strict=false):
	var output:bool = self.state == State.RUNNING
	if output and event_stack:

		# Allow to check if it's the last step until waiting for semaphore
		if _strict:
			output = output and event_stack[0][1] > event_stack[0][2]

		else:
			output = output and event_stack[0][1] >= event_stack[0][2]

	return output

func get_event_name():
	var output = ""
	if event_stack:
		output = event_stack[0][0]

	return output

func get_parent_event_name():
	var output = ''
	if event_stack.size() > 1:
		output = event_stack[1][0]

	return output

## Version control
func _get_dialogue_script_hash():
	return load("res://res://addons/Rakugo/lib/nodes/dialogue.gd")._get_script_hash()

func _get_script_hash(object=self):
	return object.get_script().source_code.hash()

func check_for_version_error(store):
	if store.dialogue_class_script_version != _class_script_version:
		push_warning("Dialogue class script mismatched.")

	if store.current_dialogue_script_version != _script_version:

		if version_control:
			push_error("The loaded save is not compatible with this version of the game.")
			return true

		else:
			push_warning("Dialogue script mismatched, that may corrupt the game state.")
	return false

## Rakugo statement wrap
func set_var(var_name: String, value):
	if is_active():
		return Rakugo.store.call_deferred('set', var_name, value)

	return null


func say(character, text:String, parameters: Dictionary = {}) -> void:
	if is_active():
		Rakugo.call_deferred('say', character, text, parameters)


func ask(default_answer:String, parameters: Dictionary = {}):
	if is_active():
		return_lock = Semaphore.new()
		var returns = [null]
		_ask_yield(returns)
		Rakugo.call_deferred('ask', default_answer, parameters)
		return_lock.wait()
		return_lock = null
		return returns[0]

	return null

func _ask_yield(returns:Array):
	returns[0] = yield(Rakugo, "ask_return")

	if return_lock:
		return_lock.post()


func menu(choices:Array, parameters: Dictionary = {}):
	if is_active():
		return_lock = Semaphore.new()
		var returns = [null]
		_menu_yield(returns)
		Rakugo.call_deferred('menu', choices, parameters)
		return_lock.wait()
		return_lock = null
		return returns[0]

	return null

func _menu_yield(returns:Array):
	returns[0] = yield(Rakugo, "menu_return")
	if return_lock:
		return_lock.post()

func show(node_id: String, parameters := {}):
	if is_active():
		Rakugo.call_deferred('show', node_id, parameters)

func hide(node_id: String) -> void:
	if is_active():
		Rakugo.call_deferred('hide', node_id)

func notify(text: String, parameters:Dictionary = {}) -> void:
	if is_active():
		Rakugo.call_deferred('notify', text, parameters)

func call_ext(object, func_name:String, args := []) -> void:
	if is_active():
		if object:
			object.call_deferred("callv", func_name, args)

func call_ext_ret(object, func_name:String, args := []):
	if is_active():

		if object:
			return_lock = Semaphore.new()
			var returns = [null]
			self.call_deferred("_call_ext_ret_call", returns,  object, func_name, args)
			return_lock.wait()
			return_lock = null
			return returns[0]

	return null

func _call_ext_ret_call(returns:Array, object, func_name:String, args:Array):
	returns[0] = object.callv(func_name, args)

	if return_lock:
		return_lock.post()

func jump(scene_id: String, dialogue_name:="", event_name:="") -> void:
	if is_active():
		Rakugo.call_deferred('jump', scene_id, dialogue_name, event_name)
