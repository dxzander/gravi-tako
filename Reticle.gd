extends Node3D

var rotation_speed: float = 0.025
var max_top_angle: float = deg_to_rad(165.0)
var max_bot_angle: float = deg_to_rad(20.0)
var input_dir := Vector2.ZERO

var inter_speed: float = 0.025
var vert_dif: float = 0.0
var hor_dif: float = 0.0

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
	input_dir = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up").normalized()
	
	# horizontal rotation
	rotate(player.basis.y, rotation_speed * input_dir.x * 2.0)
	
	# vertical rotation
	curFront = basis.z
	#curRotVer = curFront.signed_angle_to(player.basis.y, $"../Camera".global_transform.basis.x)
	curRotVer = curFront.angle_to(player.basis.y)
	if curRotVer > max_top_angle: #too above
		print("too above")
		if input_dir.y < 0:
			apply_rotation()
	elif curRotVer < max_bot_angle: #too below
		print("too below")
		if input_dir.y > 0:
			apply_rotation()
	else: #perfect
		apply_rotation()
	
	# move towards center
	# vertical
	vert_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.x) + deg_to_rad(15.0)
	rotate($"../Camera".global_transform.basis.x, rotation_speed * vert_dif)

	#horizontal
	hor_dif = curFront.signed_angle_to(player.global_transform.basis.z, player.global_transform.basis.y)
	rotate(player.basis.y, rotation_speed * (hor_dif + input_dir.x * Globals.sensibility_modifier))
	pass

func apply_rotation() -> void:
	rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y * Globals.sensibility_modifier)
	pass
