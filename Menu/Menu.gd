extends Control

func _ready():
	var resolution = DisplayServer.screen_get_size()
	get_tree().root.set_size(resolution)
	AudioServer.set_bus_volume_db(0, linear_to_db(Globals.music_volume))
	%"Pause-Start".grab_focus()
	pass

func _process(_delta):
	if Globals.in_game:
		if Input.is_action_just_pressed("Pause"):
			if get_tree().paused == false:
				_set_pause()
			else:
				_unpause()
	pass

func _set_pause() -> void:
	get_tree().paused = true
	$Menu.show()
	%"Pause-Start".grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _unpause() -> void:
	get_tree().paused = false
	$Menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _on_pause_start_pressed():
	if !Globals.in_game:
		get_node("/root/Main").add_child(preload("res://Demo Level/Game.tscn").instantiate())
		get_node("/root/Main/tako menu").free()
		%"Pause-Start".text = 'Resume'
		%Title.text = "- Paused -"
		$Menu.hide()
		%Exit.show()
		Globals.in_game = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		_unpause()
	pass

func _on_back_pressed():
	get_node("/root/Main").add_child(preload("res://Menu/tako_menu.tscn").instantiate())
	get_node("/root/Main/Game").free()
	%"Pause-Start".text = 'Start Game'
	%Title.text = "gravi-tako!"
	%Exit.hide()
	_unpause()
	$Menu.show()
	Globals.in_game = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_window_mode_pressed():
	if Globals.fullscreen:
		get_tree().root.set_mode(Window.MODE_MAXIMIZED)
		Globals.fullscreen = false
	else:
		get_tree().root.set_mode(Window.MODE_FULLSCREEN)
		Globals.fullscreen = true
	pass

func _on_scale_pressed():
	var scale_factor: float
	if Globals.half_res:
		scale_factor = 1
		Globals.half_res = false
		get_tree().root.set_content_scale_mode(Window.CONTENT_SCALE_MODE_DISABLED)
	else:
		scale_factor = 2
		Globals.half_res = true
		get_tree().root.set_content_scale_mode(Window.CONTENT_SCALE_MODE_VIEWPORT)
	ProjectSettings.set("rendering/scaling_3d/scale", 1 / scale_factor)
	RenderingServer.global_shader_parameter_set('outline_width', Globals.default_outlines_width / scale_factor)
	Globals.scalling_changed.emit()
	pass

func _on_cam_slider_value_changed(value):
	Globals.sensibility_modifier = value
	pass

func _on_vol_slider_value_changed(value):
	Globals.music_volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(Globals.music_volume))
	pass

func _on_button_pressed():
	get_tree().quit()
	pass

func _on_shadows_pressed():
	if Globals.shadows_on == false:
		Globals.shadows_on = true
	else:
		Globals.shadows_on = false
	Globals.shadows_changed.emit(Globals.shadows_on)
	pass # Replace with function body.
