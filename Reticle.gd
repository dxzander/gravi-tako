extends Node3D

var rotation_speed: float = 0.025
var max_top_angle: float = deg_to_rad(-170.0)
var max_bot_angle: float = deg_to_rad(-20.0)
#var max_angle: float = 80.0
var input_dir := Vector2.ZERO

var inter_speed: float = 0.01
var curTar := Vector3.FORWARD
var realTar := Vector3(0, 0, 0)
var lerpedTar := Vector3(0, 0, 0)

@export var player = Node3D

@onready var curFront: Vector3 = basis.z
@onready var curRotVer: float = curFront.signed_angle_to(player.get_up(), $"../Camera".global_transform.basis.x)

func _ready():
	pass

func _physics_process(delta):
	# movement and reorientation
	global_position = player.global_position
	
	## aim
	# get input
	input_dir = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up").normalized()
	
	# horizontal rotation
	rotate(player.get_up(), rotation_speed * input_dir.x)
	
	# vertical rotation
	curFront = basis.z
	curRotVer = curFront.signed_angle_to(player.get_up(), $"../Camera".global_transform.basis.x)
	if curRotVer < max_top_angle: #too above
		if input_dir.y < 0:
			rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y)
	elif curRotVer > max_bot_angle: #too below
		if input_dir.y > 0:
			rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y)
	else: #perfect
		rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y)
	pass
