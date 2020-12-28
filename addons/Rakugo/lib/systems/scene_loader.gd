extends Node

var default_force_reload = false
var scene_links:Dictionary = {}
var inverse_scene_links:Dictionary = {}
var preloaded_scenes:Dictionary = {}
var preloaded_scenes_lock:Mutex
var current_scene:String = ''
var current_scene_node:Node

var previous_scene:Node

signal scene_changed(scene_node)
#Assess the need of those
signal load_scene(resource_interactive_loader)
signal loading_scene()
signal scene_loaded()


func _ready():
	default_force_reload = Settings.get("rakugo/game/scenes/force_reload")
	preloaded_scenes_lock = Mutex.new()
	scene_links = load(Settings.get("rakugo/game/scenes/scene_links")).get_as_dict()
	current_scene = Settings.get("application/run/main_scene")
	current_scene_node = get_tree().current_scene
	
	for k in scene_links.keys():
		inverse_scene_links[scene_links[k]] = k
	current_scene = inverse_scene_links[current_scene]
	preload_scenes()

func _store(store):
	store.current_scene = current_scene

func _restore(store):
	if store.current_scene != current_scene or default_force_reload:
		load_scene(store.current_scene)

func preload_scenes():
	var load_threads = {}
	
	var i = 0
	for k in scene_links.keys():
		print("Starting preloading '%s'" % k)
		load_threads[k] = Thread.new()
		load_threads[k].start( self, "_thread_load", [load_threads[k], k, scene_links[k]])
		i += 1
	
	for k in scene_links.keys():
		print("Waiting for preloading to finish. Still %d to go." % i)
		load_threads[k].wait_to_finish()
		i -= 1 
	
	preloaded_scenes_lock.unlock()


func preload_scene(scene_entry):
	var load_thread = Thread.new()
	load_thread.start( self, "_thread_load", [load_thread, scene_entry[0], scene_entry[1]])
	load_thread.wait_to_finish()


func load_scene(scene:String, force_reload = default_force_reload):
	var scene_entry = get_scene_entry(scene)
	
	if current_scene == scene_entry[0] and not force_reload:
		return

	preloaded_scenes_lock.lock()
	if not scene_entry[0] in preloaded_scenes or force_reload:
		preloaded_scenes_lock.unlock()
		preload_scene(scene_entry)
	preloaded_scenes_lock.unlock()
	
	
	preloaded_scenes_lock.lock()
	if not scene_entry[0] in preloaded_scenes:# If the scene is still not loaded.
		preloaded_scenes_lock.unlock()
		push_error("Scene '%s' unable to be loaded." % scene)
		return null
	else:
		var output = preloaded_scenes[scene_entry[0]]
		preloaded_scenes_lock.unlock()
		current_scene = scene_entry[0]
		previous_scene = current_scene_node # Prevent previous scene to be freed too soon (in case a Dialogue Thread is not yet finished) 
		current_scene_node = output.instance()
		Rakugo.clean_scene_anchor()
		Rakugo.scene_anchor.add_child(current_scene_node)
		emit_signal("scene_changed", current_scene_node)
		return current_scene_node


func get_scene_entry(scene):
	var scene_path
	var scene_id
	if not scene in self.scene_links:
		if not scene_id in self.inverse_scene_links:
			push_warning("Scene '%s' not found in linker" % scene_id)
			scene_id = scene.get_file()
		else:
			scene_id = self.inverse_scene_links[scene_id]
		scene_path = scene
	else:
		scene_id = scene
		scene_path = self.scene_links[scene]
	return [scene_id, scene_path]



func _thread_load(data):
	var thread = data[0]
	var key = data[1]
	var path = data[2]
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	self.call_deferred('emit_signal', 'load_scene', ril)

	var res = null

	while not res:
		var err = ril.poll()
		self.call_deferred('emit_signal', 'loading_scene')
		res = ril.get_resource()

		if not res and err != OK:
			push_error("There was an error loading")
			break
	self.call_deferred('emit_signal', 'scene_loaded')
	preloaded_scenes_lock.lock()
	preloaded_scenes[key] = res
	preloaded_scenes_lock.unlock()
