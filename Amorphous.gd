extends CharacterBody3D

var SPEED := 10.0
var rotation_speed := 4.0
var JUMP_DIR := Vector3.UP
var input_dir := Vector2.ZERO

var upOrientation := Vector3.UP
var frontOrientation := Vector3.FORWARD
var rightOrientation := Vector3.RIGHT

var wall_normal := Vector3.UP
var inertia := Vector3.DOWN
var direction := Vector3.ZERO
var global_direction := Vector3.ZERO

var target_basis := Basis()
var cam_basis := Basis()

var curTar := Vector3.ZERO
var realTar := Vector3.ZERO
var lerpedTar := Vector3.ZERO

@onready var previous_position: Vector3 = position
@onready var fl_leg: Node3D = $Marks/MarkFL
@onready var fr_leg: Node3D = $Marks/MarkFR
@onready var bl_leg: Node3D = $Marks/MarkBL
@onready var br_leg: Node3D = $Marks/MarkBR

func _on_ready():
	#set_floor_block_on_wall_enabled(false)
	pass

func _physics_process(delta):
	# for debugging
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	#rotate(Vector3(0.0, 1.0, 0.0), 0.01)
	
	print(is_on_wall())
	
	# handle movement
	if Input.is_action_just_pressed("ui_accept") and is_on_wall():
		# jump takes priority
		JUMP_DIR = upOrientation + direction
		velocity = JUMP_DIR * SPEED
		inertia = JUMP_DIR
	elif is_on_wall():
		# movement while "grounded"
		
		# get input
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		
		# transform input based on camera
		cam_basis = $Camera.global_transform.basis
		direction = cam_basis * Vector3(input_dir.x, 0, input_dir.y)
		global_direction = direction * global_basis
		
		direction = Vector3(direction.x, 0, direction.z).normalized()
		global_direction = Vector3(global_direction.x, 0, global_direction.z).normalized()
		
		# set direction marker position 
		if global_direction.length() == 1.0:
			$Dir.position = global_direction
		velocity = direction * SPEED
		
		# get wall orientation
		wall_normal = get_wall_normal()
		inertia = wall_normal
		#inertia = (previous_position - position).normalized() #for later
	else:
		# intertial movement
		velocity = inertia * SPEED
	
	# apply whatever movement was calculated
	previous_position = position
	move_and_slide()
	
	# apply whatever rotation
	# handle rotation
	### THIS IS THE GOOD ONE
	if global_direction.length() == 1.0:
		target_basis = transform.looking_at($Dir.global_transform.origin, wall_normal).basis
	else:
		target_basis = _basis_from_normal(wall_normal)
	
	transform.basis = lerp(transform.basis.orthonormalized(), target_basis, SPEED * delta).orthonormalized()
	
	# update variables
	upOrientation = global_position.direction_to($Up.global_transform.origin).normalized()
	frontOrientation = global_position.direction_to($Front.global_transform.origin).normalized()
	rightOrientation = global_position.direction_to($Right.global_transform.origin).normalized()
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
