extends Control

@export var resolutions_array : Array[Vector2i] = [
	Vector2i(960, 540),
	Vector2i(1024, 576),
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2048, 1152),
	Vector2i(2560, 1440),
	Vector2i(3200, 1800),
	Vector2i(3840, 2160),
]

@onready var fullscreen_button = %FullscreenButton
@onready var resolution_options = %ResolutionOptions
@onready var gui_scale_slider = %GuiScaleHSlider

@onready var timer = $Timer
@onready var confirm_dialog = $ConfirmationDialog
@onready var apply_button = $ApplyButton

var tmp_resolution:Vector2i
var tmp_gui_scale:float

func _ready():
	var main_window = get_window()
	
	fullscreen_button.set_pressed_no_signal(main_window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN)

	if OS.has_feature("web"):
		resolution_options.disabled = true
		resolution_options.tooltip_text = "Disabled for web"
	else:
		for resolution in resolutions_array:
			resolution_options.add_item(str(resolution.x) + " x " + str(resolution.y))
			
		var current_resolution = main_window.content_scale_size
		
		tmp_resolution = current_resolution
		
		var index = resolutions_array.find(current_resolution)
		
		if index != -1:
			resolution_options.select(index)
		
		var current_gui_scale = main_window.content_scale_factor
		
		tmp_gui_scale = current_gui_scale
		
		gui_scale_slider.value = current_gui_scale

func _on_fullscreen_button_toggled(toggled_on):
	AppSettings.set_fullscreen(toggled_on)

func _on_apply_button_pressed() -> void:
	apply_button.disabled = true
	
	var main_window = get_window()
	
	var index = resolution_options.selected
	
	if index != -1:
		tmp_resolution = main_window.content_scale_size
		
		AppSettings.set_resolution(resolutions_array[index])
	
	tmp_gui_scale = main_window.content_scale_factor
	
	AppSettings.set_gui_scale(gui_scale_slider.value)
	
	timer.start()
	
	confirm_dialog.popup()

func reset_resolution_and_scale() -> void:
	var main_window = get_window()
	
	AppSettings.set_resolution(tmp_resolution)
	
	var index = resolutions_array.find(main_window.content_scale_size)
		
	if index != -1:
		resolution_options.select(index)
	
	AppSettings.set_gui_scale(tmp_gui_scale)
	
	gui_scale_slider.value = main_window.content_scale_factor

func _on_confirmation_dialog_canceled() -> void:
	timer.stop()
	
	reset_resolution_and_scale()

func _on_confirmation_dialog_confirmed() -> void:
	timer.stop()
	
	var main_window = get_window()
	
	tmp_resolution = main_window.content_scale_size
	
	tmp_gui_scale = main_window.content_scale_factor

func _on_timer_timeout() -> void:
	confirm_dialog.hide()
	
	reset_resolution_and_scale()

func enable_or_disable_apply_button():
	if tmp_gui_scale != gui_scale_slider.value \
	or tmp_resolution != resolutions_array[max(resolution_options.selected, 0)]:
		apply_button.disabled = false
		return
		
	apply_button.disabled = true

func _on_gui_scale_h_slider_value_changed(_value: float) -> void:
	enable_or_disable_apply_button()

func _on_resolution_options_item_selected(_index: int) -> void:
	enable_or_disable_apply_button()
