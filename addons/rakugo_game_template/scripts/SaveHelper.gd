extends Object
class_name SaveHelper
## Helps to save data in [JSON] format
##
## Here is a sample on how to save data:
## [codeblock]
## var data_to_save := {"something":"Something"}
## if SaveHelper.save(data_to_save) != OK:
##   push_error("Cannot save data")
## [/codeblock]
## And how to load and use them:
## [codeblock]
## SaveHelper.update_save_file_names()
##
## if SaveHelper.load_last_save() != OK:
##   push_error("Cannot load data")
## var something := SaveHelper.last_saved_data["something"]
## [/codeblock]


## where the data will be saved
const save_dir_path = "user://saves"

## to avoid errors
const json_extension = "json"

## updated with SaveHelper.update_save_files_names [br]
## saved here to avoid multiples disk access [br]
## after update it, can be used to check if save(s) exist or not [br]
## should be clear with SaveHelper.clear_save_files_names to avoid
## memory consumption
static var save_file_names:PackedStringArray

## the last saved file name without extension .json
static var last_saved_file_name := ""

## use it to save the file_name to load between scenes
static var save_file_name_to_load := ""

## last loaded data [br]
## empty [Dictionary] by default
static var last_loaded_data:Dictionary = {}

## save data in a file [br]
## the file will be created in save_dir_path [br]
## the file_name will be generated from the systemTime in local time [br]
## the file_name name will look like YYYY-MM-DDTHH:MM:SS.json [br]
## yes, the user can modify his system time, so you can use this feature and/or create easter-eggs [br]
## if cannot create saves directory return ERR_CANT_CREATE [br]
## if cannot create and write in the save file return ERR_FILE_CANT_WRITE [br]
## return OK in other cases
static func save(data:Dictionary) -> Error:
	if not DirAccess.dir_exists_absolute(save_dir_path):
		if DirAccess.make_dir_absolute(save_dir_path) != OK:
			push_error("Cannot create saves directory in user://")
			return ERR_CANT_CREATE
	
	var file_name := Time.get_datetime_string_from_system()
	
	var file := FileAccess.open(save_dir_path + "/" + file_name + "." + json_extension, FileAccess.WRITE)
	if file == null:
		push_error("Cannot create the save file in " + save_dir_path)
		return ERR_FILE_CANT_WRITE
	
	var json_data = JSON.stringify(data)
	
	file.store_string(json_data)
	
	last_saved_file_name = file_name
	
	return OK

## return a file_path into the save directory from the file_name [br]
## if file_name is empty return empty String [br]
## if the extension .json is missing it will be added
static func get_save_file_path(file_name:String) -> String:
	if file_name.is_empty():
		return ""
	
	if not file_name.get_extension() == json_extension:
		file_name += "." + json_extension
	
	return save_dir_path + "/" + file_name

## return a file_path into the save directory from the file_name [br]
## if the extension .json is present it will be removed
## if file_name is empty return empty String
static func get_save_file_path_without_extension(file_name:String) -> String:
	if file_name.is_empty():
		return ""
	
	return save_dir_path + "/" + file_name.trim_suffix("." + json_extension)
	
## load data from file [br]
## file_name should looks like YYYY-MM-DDTHH:MM:SS.json [br]
## if file_name is empty return ERR_INVALID_PARAMETER [br]
## if the extension .json is missing it will be added [br]
## if the file cannot be opened and read return ERR_FILE_CANT_READ [br]
## if the file cannot be parsed to [JSON] return ERR_INVALID_DATA [br]
## return OK in other cases and save the parsed result in last_loaded_data
static func load(file_name:String) -> Error:
	if file_name.is_empty():
		push_warning("file_name is empty !")
		return ERR_INVALID_PARAMETER
	
	var file_path := get_save_file_path(file_name)
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Cannot open the save file: " + file_path)
		return ERR_FILE_CANT_READ
	
	var json_data := file.get_as_text()
	
	var parsed_json = JSON.parse_string(json_data)
	
	if parsed_json == null:
		last_loaded_data = {}
		
		push_error("Cannot parse to json the save file")
		return ERR_INVALID_DATA
	
	last_loaded_data = parsed_json
	
	return OK
	
## Call SaveHelper.load(save_file_name_to_load) [br]
## if save_file_name_to_load is empty return ERR_INVALID_PARAMETER
static func load_saved_file_name() -> Error:
	return SaveHelper.load(save_file_name_to_load)

## warning, make disk access, avoid multiples use [br]
## set SaveHelper.save_file_names
static func update_save_file_names() -> Error:
	var dirAccess := DirAccess.open(save_dir_path)
	if dirAccess == null:
		push_warning("Cannot open the save directory")
		return FAILED
	
	save_file_names.clear()
	
	dirAccess.list_dir_begin()
	
	var file_name = dirAccess.get_next()

	while not file_name.is_empty():
		if not dirAccess.current_is_dir() \
		and file_name.get_extension() == json_extension:
			save_file_names.push_back(file_name.left(file_name.rfind(".")))
			
		file_name = dirAccess.get_next()
	
	if not save_file_names.is_empty():
		save_file_names.sort()
	
	return OK

## set SaveHelper.save_file_name_to_load with last saved name [br]
## if save_files_names is empty return ERR_DOES_NOT_EXIST [br]
## return OK in other cases
static func update_with_last_saved_name() -> Error:
	if save_file_names.is_empty():
		push_warning("No save to load")
		return ERR_DOES_NOT_EXIST
		
	save_file_name_to_load = save_file_names[-1]
		
	return OK

## move to trash the save file [br]
## file_name should looks like YYYY-MM-DDTHH:MM:SS.json [br]
## if file_name is empty return ERR_INVALID_PARAMETER [br]
## if the extension .json is missing it will be added [br]
## if the file cannot be found return ERR_FILE_NOT_FOUND [br]
## return OS.move_to_trash(...) in other cases
static func delete(file_name:String) -> Error:
	if file_name.is_empty():
		push_warning("file_name is empty !")
		return ERR_INVALID_PARAMETER
	
	var file_path := get_save_file_path(file_name)
	
	if not FileAccess.file_exists(file_path):
		push_error("Cannot found the save file: " + file_path)
		return ERR_FILE_NOT_FOUND
	
	return OS.move_to_trash(ProjectSettings.globalize_path(file_path))
