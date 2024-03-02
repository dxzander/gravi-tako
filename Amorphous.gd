extends CharacterBody3D

var rotation_speed = 0.01
var orientation = Vector3(0.0, 1.0, 0.0)

func _physics_process(delta):
	#rotate(Vector3(0.0, 0.0, 1.0), rotation_speed)
	orientation = global_position.direction_to($Up.global_transform.origin)
	pass
	
func get_up():
	return orientation
