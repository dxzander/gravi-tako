extends CharacterBody3D

var SPEED: float = 2000.0
var inter_speed: float = 10.0
var rotation_speed: float = 4.0
var JUMP_DIR := up_direction
var input_dir := Vector2.ZERO

var upOrientation := Vector3.UP
var frontOrientation := Vector3.FORWARD
var rightOrientation := Vector3.RIGHT

@onready var wall_normal := up_direction.normalized()
@onready var inertia := -up_direction.normalized()
@onready var direction := Vector3.ZERO
@onready var global_direction := Vector3.ZERO
@onready var changed: bool = true

var target_basis := Basis()
var cam_basis := Basis()

func _on_ready():
	#set_floor_block_on_wall_enabled(false)
	update_directions()
	pass

func _physics_process(delta):
	# for debugging
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	if up_direction == Vector3.ZERO:
		up_direction = Vector3.UP
	
	if Input.is_action_just_pressed("db_up"):
		print("db_up")
		inertia = Vector3.UP
	elif Input.is_action_just_pressed("db_down"):
		print("db_down")
		inertia = Vector3.DOWN
	elif Input.is_action_just_pressed("db_right"):
		print("db_right")
		inertia = Vector3.RIGHT
	elif Input.is_action_just_pressed("db_left"):
		print("db_left")
		inertia = Vector3.LEFT
	elif Input.is_action_just_pressed("db_front"):
		print("db_front")
		inertia = Vector3.FORWARD
	elif Input.is_action_just_pressed("db_back"):
		print("db_back")
		inertia = Vector3.BACK
	
	if Input.is_action_just_pressed("db_ar"):
		print("db_ar")
		global_direction = _basis_from_normal(wall_normal).z.normalized()
	elif Input.is_action_just_pressed("db_ab"):
		print("db_ab")
		global_direction = -_basis_from_normal(wall_normal).z.normalized()
	elif Input.is_action_just_pressed("db_iz"):
		print("db_iz")
		global_direction = -_basis_from_normal(wall_normal).x.normalized()
	elif Input.is_action_just_pressed("db_de"):
		print("db_de")
		global_direction = _basis_from_normal(wall_normal).x.normalized()
	
	if Input.is_action_just_pressed("db_zero"):
		print("db_zero")
		reset()
	
	# handle movement
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# jump takes priority
		JUMP_DIR = upOrientation + direction
		inertia = JUMP_DIR
		velocity = inertia * SPEED
	elif Input.is_action_just_pressed("shoot") and is_on_floor() and Input.is_action_pressed("aim"):
		# then shoot, which is just jump with extra steps
		JUMP_DIR = global_position.direction_to($Reticle/Reticle3D.global_transform.origin).normalized()
		inertia = JUMP_DIR
		velocity = inertia * SPEED
	elif is_on_floor() and not Input.is_action_pressed("aim"):
		# movement while "grounded"
		
		# get input
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		
		# transform input based on camera
		cam_basis = $Camera.global_transform.basis
		direction = cam_basis * Vector3(input_dir.x, 0, input_dir.y)
		global_direction = direction * global_basis
		global_direction = Vector3(global_direction.x, 0, global_direction.z).normalized()
		
		# set direction marker position 
		if global_direction.length() == 1.0:
			$Dir.position = global_direction
		velocity = (direction + inertia) * SPEED
		
		# get wall orientation
		wall_normal = get_floor_normal()
		inertia = -wall_normal
		changed = false
	elif is_on_wall() or is_on_ceiling():
		if is_on_wall():
			wall_normal = get_wall_normal()
		if is_on_ceiling():
			wall_normal = -get_up_direction()
		inertia = -wall_normal
		velocity = inertia * SPEED
		changed = true
	else:
		# intertial movement
		velocity = inertia * SPEED
		pass
	
	# apply whatever rotation and translation was calculated
	# handle rotation
	### THIS IS THE GOOD ONE
	if global_direction.length() == 1.0 or changed:
		target_basis = transform.looking_at($Dir.global_transform.origin, wall_normal).basis.orthonormalized()
	else:
		target_basis = _basis_from_normal(wall_normal)
		pass
		
	transform.basis = lerp(transform.basis, target_basis, inter_speed * delta).orthonormalized()
	
	# update variables
	update_directions()
	set_up_direction(wall_normal)
	
	# apply whatever movement was calculated
	velocity *= delta
	move_and_slide()
	
	pass

func get_up() -> Vector3:
	return upOrientation

func get_front() -> Vector3:
	return frontOrientation

func get_right() -> Vector3:
	return rightOrientation

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	#result.x *= scale.x
	#result.y *= scale.y
	#result.z *= scale.z
	return result

func is_close_enough(a: Vector3, b: Vector3) -> bool:
	var is_it: bool = false
	if a.is_equal_approx(b) and b.is_equal_approx(a):
		is_it = true
	return is_it

func update_directions() -> void:
	upOrientation = global_position.direction_to($Up.global_transform.origin).normalized()
	frontOrientation = global_position.direction_to($Front.global_transform.origin).normalized()
	rightOrientation = global_position.direction_to($Right.global_transform.origin).normalized()
	pass

func get_cam_global_transform() -> Transform3D:
	return $Camera/Cam.global_transform

func reset() -> void:
	transform.basis = Basis()
	global_direction = Vector3.ZERO
	$Dir.position = global_direction
	up_direction = Vector3.UP
	wall_normal = up_direction
	inertia = -up_direction
	direction = Vector3.ZERO
	changed = true
	pass
