<<<<<<< HEAD
extends Node

var thread = null

onready var scene_links:Dictionary = {}
onready var current_scene:String = ''


signal load_scene(resource_interactive_loader)
signal loading_scene()
signal scene_loaded()

func _ready():
	scene_links = load(Settings.get("rakugo/game/scenes/scene_links")).get_as_dict()
	current_scene = Settings.get("application/run/main_scene")
	for k in scene_links.keys():
		if scene_links[k] == current_scene:
			current_scene = k


func _store(store):
	store.current_scene = current_scene

func _restore(store):
	load_scene(store.current_scene)


func load_scene(scene_id, force_reload = false):
	if self.thread and self.thread.is_active():
		push_warning("A scene is already being loaded")
	
	elif not scene_id in scene_links:
		push_error("Scene '%s' not found in linker" % scene_id)
	
	elif force_reload or self.current_scene != scene_id:
		get_tree().paused = true
		Rakugo.exit_dialogue()

		self.thread = Thread.new()
		self.thread.start( self, "_thread_load", self.scene_links[scene_id])

		self.current_scene = scene_id
		return true
	
	return false


func load_packed_scene(packed_scene_path):
	if self.thread and self.thread.is_active():
		push_warning("A scene is already being loaded")
	elif not packed_scene_path in scene_links.values():
		push_warning("Scene '%s' not found in linker" % packed_scene_path)

	var scene_id = packed_scene_path
	for k in scene_links.keys():
		if self.scene_links[k] == packed_scene_path:
			scene_id = k
			break
		
	get_tree().paused = true
	Rakugo.exit_dialogue()

	self.thread = Thread.new()
	self.thread.start( self, "_thread_load", packed_scene_path)

	self.current_scene = scene_id


func _thread_load(path):
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

	call_deferred("_thread_done", res)


func _thread_done(resource):
	assert(resource)

	thread.wait_to_finish()

	# Instantiate new scene
	var new_scene = resource.instance()
	Rakugo.ShowableManager.declare_showables(new_scene)

	# Free current scene
	Rakugo.clean_scene_anchor()

	Rakugo.scene_anchor.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	get_tree().paused = false
	self.emit_signal("scene_loaded")
=======
extends Node

var thread = null

onready var scene_links:Dictionary = {}
onready var inverse_scene_links:Dictionary = {}
onready var current_scene:String = ''


signal load_scene(resource_interactive_loader)
signal loading_scene()
signal scene_loaded()

func _ready():
	scene_links = load(Settings.get("rakugo/game/scenes/scene_links")).get_as_dict()
	current_scene = Settings.get("application/run/main_scene")
	for k in scene_links.keys():
		inverse_scene_links[scene_links[k]] = k
	current_scene = inverse_scene_links[current_scene]


func _store(store):
	store.current_scene = current_scene

func _restore(store):
	load_scene(store.current_scene)


func load_scene(scene:String, force_reload = false):
	if self.thread and self.thread.is_active():
		push_error("A scene is already being loaded")

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
	
	if force_reload or self.current_scene != scene_id:
		get_tree().paused = true
		Rakugo.exit_dialogue()
		self.current_scene = scene_id

		self.thread = Thread.new()
		self.thread.start( self, "_thread_load", scene_path)

		return true
	
	return false


func _thread_load(path):
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

	call_deferred("_thread_done", res)


func _thread_done(resource):
	assert(resource)

	thread.wait_to_finish()
	
	# Free current scene
	Rakugo.clean_scene_anchor()
	
	# Instantiate new scene
	var new_scene = resource.instance()
	Rakugo.ShowableManager.declare_showables(new_scene)
	Rakugo.scene_anchor.add_child(new_scene)
	#get_tree().set_current_scene(new_scene)
	
	get_tree().paused = false
	print(Rakugo.current_dialogue)
	self.emit_signal("scene_loaded")
>>>>>>> f4a81ea87c9bba54a08d3ac43a556af80a7ac575
