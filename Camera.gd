extends Node3D

var rotation_speed = 0.1
var curTar = Vector3(0, 0, 0)
var realTar = Vector3(0, 0, 0)
var lerpedTar = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	realTar = $"../Reticle/Reticle3D".global_transform.origin
	lerpedTar = curTar.lerp(realTar, rotation_speed)
	look_at(lerpedTar, get_parent().get_up())
	curTar = lerpedTar
	$Raymond.set_target_position(realTar)
	if $Raymond.is_colliding():
		#print($Raymond.get_collider().name)
		pass
	pass
