extends Node3D

var rotation_speed: float = 0.1
var curTar := Vector3(0, 0, 0)
var realTar := Vector3(0, 0, 0)
var lerpedTar := Vector3(0, 0, 0)
var cam_default_position := Vector3(0,9,12)

@export var target = Node3D
@export var player = Node3D

signal target_found
signal target_lost

func _physics_process(delta):
	# movement
	global_position = player.global_position + player.get_up()
	
	# aim
	realTar = target.global_position
	lerpedTar = curTar.lerp(realTar, rotation_speed)
	look_at(lerpedTar, player.get_up())
	curTar = lerpedTar
	
	# collision
	if $RayCam.is_colliding():
		$Cam.global_position = $RayCam.get_collision_point() - player.global_position.direction_to($RayCam.get_collision_point())
	else:
		$Cam.position = cam_default_position
	
	# aim
	if $RayAim.is_colliding():
		target_found.emit()
	else:
		target_lost.emit()
