extends Node3D

var rotation_speed = 0.1
var curTar = Vector3(0, 0, 0)
var realTar = Vector3(0, 0, 0)
var lerpedTar = Vector3(0, 0, 0)
var cam_default_position = Vector3(0,11,22)

@export var target = Node3D
@export var player = Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#realTar = ((target.global_transform.origin + player.global_transform.origin) / 2).normalized()
	global_position = player.global_position + player.get_up()
	realTar = target.global_position
	lerpedTar = curTar.lerp(realTar, rotation_speed)
	look_at(lerpedTar, player.get_up())
	curTar = lerpedTar
	if $RayCam.is_colliding():
		print($RayCam.get_collision_point())
		$Cam.global_position = $RayCam.get_collision_point() - cam_default_position.normalized()
	else:
		$Cam.position = cam_default_position
