extends Skeleton3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3(0.0, 1.0, 0.0), 0.5 * delta)
	rotate(Vector3(0.0, 0.0, -1.0), 0.2 * delta)
	pass
