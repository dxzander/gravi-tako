extends Node3D

var rotation_speed = 0.025
var max_angle = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var input_dir = Input.get_vector("cam_right", "cam_left", "cam_up", "cam_down")
	var curRotHor = get_rotation_degrees().x
	rotate(Vector3(0.0, 1.0, 0.0), rotation_speed * input_dir.x)
	if curRotHor <= max_angle and curRotHor >= -max_angle:
		rotate_object_local(Vector3(1.0, 0.0, 0.0), rotation_speed / 2 * -input_dir.y)
	else:
		set_rotation_degrees(Vector3((curRotHor / abs(curRotHor)) * max_angle, get_rotation_degrees().y, get_rotation_degrees().z))
	pass
