extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rotation_speed = 0.01
var orientation = Vector3(0.0, 1.0, 0.0)

func _on_ready():
	gravity = get_up()

func _physics_process(delta):
	#rotate(Vector3(0.0, 0.0, 1.0), rotation_speed)
	get_up()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	pass
	
func get_up():
	orientation = global_position.direction_to($Up.global_transform.origin)
	return orientation
