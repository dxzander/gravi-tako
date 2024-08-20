extends RayCast3D

signal collision_point(point)

var point: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_colliding():
		point = get_collision_point()
		collision_point.emit(point)
	pass
