extends Control

# states
# true in game
# false menu

var in_game: bool = false;
var is_fullscreen: bool = false;
var half_res: bool = false;

func _ready():
	$"Menu/Menu/MarginContainer/VBoxContainer/Menu/Pause-Start".grab_focus()
	var resolution = DisplayServer.screen_get_size()
	get_tree().root.set_size(resolution)
	AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
	pass

func _process(delta):
	if in_game:
		if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
			_set_pause()
		elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
			_unpause()
	pass

func is_in_game() -> bool:
	return in_game

func _set_pause() -> void:
	get_tree().paused = true
	$Menu.show()
	$"Menu/Menu/MarginContainer/VBoxContainer/Menu/Pause-Start".grab_focus()
	pass

func _unpause() -> void:
	get_tree().paused = false
	$Menu.hide()
	pass

func _on_pause_start_pressed():
	if not in_game:
		get_node("/root/Main").add_child(preload("res://Game.tscn").instantiate())
		get_node("/root/Main/tako menu").free()
		$"Menu/Menu/MarginContainer/VBoxContainer/Menu/Pause-Start".text = 'Resume'
		$Menu/Menu/MarginContainer/VBoxContainer/Menu/Title.text = "- Paused-"
		$Menu.hide()
		$Menu/Menu/MarginContainer/VBoxContainer/Menu/Back.show()
		in_game = true
	else:
		_unpause()
	pass

func _on_back_pressed():
	get_node("/root/Main").add_child(preload("res://tako_menu.tscn").instantiate())
	get_node("/root/Main/Game").free()
	$"Menu/Menu/MarginContainer/VBoxContainer/Menu/Pause-Start".text = 'Start Game'
	$Menu/Menu/MarginContainer/VBoxContainer/Menu/Back.hide()
	_unpause()
	$Menu.show()
	in_game = false
	pass


func _on_window_mode_pressed():
	if get_tree().root.get_mode() == Window.MODE_WINDOWED or get_tree().root.get_mode() == Window.MODE_MAXIMIZED:
		get_tree().root.set_mode(Window.MODE_FULLSCREEN)
	elif get_tree().root.get_mode() == Window.MODE_FULLSCREEN:
		get_tree().root.set_mode(Window.MODE_MAXIMIZED)
	pass

func _on_scale_pressed():
	if $Menu/Menu/MarginContainer/VBoxContainer/Menu/Scale.button_pressed:
		print(DisplayServer.screen_get_size())
		var resolution = DisplayServer.screen_get_size()
		get_tree().root.set_size(resolution / 2)
		get_tree().root.set_content_scale_mode(Window.CONTENT_SCALE_MODE_VIEWPORT)
		RenderingServer.global_shader_parameter_set('outline_width', 3.0)
		#get_tree().root.set_mode(Window.MODE_WINDOWED)
		res_changed()
	else:
		var resolution = DisplayServer.screen_get_size()
		get_tree().root.set_size(resolution)
		get_tree().root.set_content_scale_mode(Window.CONTENT_SCALE_MODE_DISABLED)
		RenderingServer.global_shader_parameter_set('outline_width', 6.0)
		#get_tree().root.set_mode(Window.MODE_WINDOWED)
		res_changed()
	pass

func res_changed() -> void:
	if $"Menu/Menu/MarginContainer/VBoxContainer/Menu/Window Mode".button_pressed: 
		get_tree().root.set_mode(Window.MODE_FULLSCREEN)
	else:
		get_tree().root.set_mode(Window.MODE_MAXIMIZED)
	pass


func _on_cam_slider_value_changed(value):
	Globals.sensibility_modifier = value
	pass


func _on_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	pass


func _on_button_pressed():
	get_tree().quit()
	pass
