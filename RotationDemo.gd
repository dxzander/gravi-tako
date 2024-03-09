extends Node3D

var rotation_speed := 0.01

func _process(delta):
	rotate(Vector3(0.0, 1.0, 0.0), rotation_speed)
	pass
