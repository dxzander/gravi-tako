extends AnimatableBody3D

func _physics_process(delta: float) -> void:
	rotate(Vector3(0.0, 1.0, 0.0), 0.4 * delta)
	pass
