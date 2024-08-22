extends Node3D

var rotation_speed: float = 0.025
var max_top_angle: float = deg_to_rad(165.0)
var max_bot_angle: float = deg_to_rad(20.0)
var input_dir := Vector2.ZERO

var inter_speed: float = 0.025
var vert_dif: float = 0.0
var hor_dif: float = 0.0

# mouse things
var LOOKAROUND_SPEED: float = -0.001
var rot_x: float = 0.0
var rot_y: float = 0.0
var cap_y: float = 0.4

@export var player = Node3D

@onready var curFront: Vector3 = basis.z
@onready var curRotVer: float = curFront.angle_to(player.basis.y)

func _ready():
	pass

func _physics_process(delta):
	# movement and reorientation
	global_position = player.global_position
	
	## aim
	# get input
	if rot_x != 0 || rot_y != 0:
		input_dir = Vector2(rot_x, rot_y).normalized()
	else:
		input_dir = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up").normalized()
	
	if Input.is_action_pressed("aim"):
		$Reticle3D.show()
		#if $Reticle3D.is_on_wall():
			#$"Reticle3D/Reticle Sprite".texture = load("res://Reticle red.png")
		#else:
			#$"Reticle3D/Reticle Sprite".texture = load("res://Reticle green.png")
	elif Input.is_action_just_released("aim"):
		$Reticle3D.hide()
	
	# horizontal rotation
	rotate(player.basis.y, rotation_speed * input_dir.x * 2.0)
	
	# vertical rotation
	curFront = basis.z
	#curRotVer = curFront.signed_angle_to(player.basis.y, $"../Camera".global_transform.basis.x)
	curRotVer = curFront.angle_to(player.basis.y)
	if curRotVer > max_top_angle: #too above
		#print("too above")
		if input_dir.y < 0:
			apply_rotation()
	elif curRotVer < max_bot_angle: #too below
		#print("too below")
		if input_dir.y > 0:
			apply_rotation()
	else: #perfect
		apply_rotation()
	
	## move towards center (moved to cam recenter method)
	## vertical
	#if !Input.is_action_pressed("aim"):
		#vert_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.x) + deg_to_rad(15.0)
	#else:
		#vert_dif = 0.0
	#rotate($"../Camera".global_transform.basis.x, rotation_speed * vert_dif)
#
	##horizontal
	#if !Input.is_action_pressed("aim"):
		#hor_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.y)
	#else:
		#hor_dif = 0.0
	#rotate(player.basis.y, rotation_speed * (hor_dif + input_dir.x * Globals.sensibility_modifier))
	cam_recenter()
	pass

func apply_rotation() -> void:
	rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y * Globals.sensibility_modifier)
	pass

func cam_recenter() -> void:
	# move towards center
	# vertical
	if !Input.is_action_pressed("aim"):
		vert_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.x) + deg_to_rad(15.0)
		hor_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.y)
	else:
		vert_dif = 0.0
		hor_dif = 0.0
	rotate($"../Camera".global_transform.basis.x, rotation_speed * vert_dif) # vertical
	rotate(player.basis.y, rotation_speed * hor_dif) # horizontal
	#rotate(player.basis.y, rotation_speed * (hor_dif + input_dir.x * Globals.sensibility_modifier)) # horizontal
	pass

# from silveriver
#func _input(event) -> void:
	#if event is InputEventMouseMotion:
		## modify accumulated mouse rotation
		#rot_x += event.relative.x * LOOKAROUND_SPEED
		#if (abs(rot_y) < cap_y) || (rot_y > 0 and event.relative.y > 0) || (rot_y <= 0 and event.relative.y < 0):
			#rot_y += event.relative.y * LOOKAROUND_SPEED
		#transform.basis = Basis() # reset rotation
		#rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		#rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X

func _input(event) -> void:
	var mouse_not_moved: bool = true
	if event is InputEventMouseMotion:
		# modify accumulated mouse rotation
		rot_x = -event.relative.x
		rot_y = -event.relative.y
		mouse_not_moved = false
	if mouse_not_moved:
		rot_x = 0.0
		rot_y = 0.0
	pass

func _on_camera_target_found():
	$"Reticle3D/Reticle Sprite".texture = load("res://gravitako/Reticle green.png")
	pass # Replace with function body.

func _on_camera_target_lost():
	$"Reticle3D/Reticle Sprite".texture = load("res://gravitako/Reticle red.png")
	position = Vector3(0,0,-15)
	pass # Replace with function body.

func _on_ray_aim_collision_point(point):
	#print("boop")
	#position = self.to_local(point)
	pass # Replace with function body.
