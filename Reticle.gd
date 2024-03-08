extends Node3D

var rotation_speed = 0.025
var max_angle = 80

@export var player = Node3D

func _ready():
	pass

func _physics_process(delta):
	global_position = player.global_position
	var input_dir = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up").normalized()
	var curRotHor = get_rotation_degrees().x
	rotate(player.get_up(), rotation_speed * input_dir.x)
	if curRotHor <= max_angle and curRotHor >= -max_angle:
		rotate($"../Camera".global_transform.basis.x, rotation_speed * input_dir.y)
	else:
		set_rotation_degrees(Vector3((curRotHor / abs(curRotHor)) * max_angle, get_rotation_degrees().y, get_rotation_degrees().z))
	pass
