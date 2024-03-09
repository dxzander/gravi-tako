extends Node3D

var rotation_speed: float = 0.025
var max_angle: float = 80.0
var input_dir := Vector2.ZERO

var inter_speed: float = 0.01
var curTar := Vector3.FORWARD
var realTar := Vector3(0, 0, 0)
var lerpedTar := Vector3(0, 0, 0)

@onready var curRotHor: float = get_rotation_degrees().x

@export var player = Node3D

func _ready():
	pass

func _physics_process(delta):
	global_position = player.global_position
	input_dir = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up").normalized()
	
	curRotHor = get_global_position().x
	rotate(player.get_up(), rotation_speed * input_dir.x)
	if curRotHor <= max_angle and curRotHor >= -max_angle:
		rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y)
	else:
		set_rotation_degrees(Vector3((curRotHor / abs(curRotHor)) * max_angle, get_rotation_degrees().y, get_rotation_degrees().z))
	pass
