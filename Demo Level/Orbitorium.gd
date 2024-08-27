extends AnimatableBody3D

func _physics_process(delta):
	rotate(Vector3(1.0, 0.0, 0.0), 0.5 * delta)
	pass
