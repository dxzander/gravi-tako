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
var last_global_direction := Vector3.FORWARD

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
	set_floor_block_on_wall_enabled(false)
	#set_max_slides(0)
	pass

func _physics_process(delta):
	# for debugging
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	#rotate(Vector3(0.0, 1.0, 0.0), 0.01)
	
	print(is_on_wall())
	
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
		transform.basis = Basis()
		global_direction = Vector3.ZERO
		$Dir.position = global_direction
	
	#print("normal: " + str(wall_normal))
	#print("direcion: " + str(global_direction))
	#print(get_real_velocity())
	
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
		#cam_basis = $Reticle.global_transform.basis.rotated($Reticle.global_transform.basis.x, $Reticle.global_transform.basis.z.angle_to(global_transform.basis.z))
		cam_basis = $Reticle.global_transform.basis
		direction = (cam_basis * Vector3(input_dir.x, 0, input_dir.y))
		#direction = $Front.global_position.normalized() * -input_dir.y
		global_direction = direction * global_basis
		#print(cam_basis)
		
		#var a = transform.basis.z.angle_to($Reticle.transform.origin)
		#var b = PI - a
		#print("z: " + str(transform.basis.z))
		#print("x: " + str(transform.basis.x))
		
		#direction = direction.rotated(transform.basis.x, -a)
		#direction = Vector3(direction.x, 0, direction.z).normalized()
		#global_direction = Vector3(global_direction.x, 0, global_direction.z).normalized()
		
		# set direction marker position 
		if global_direction.length() == 1.0:
			$Dir.position = global_direction
		#velocity = direction.rotated($Camera.global_transform.basis.x, direction.signed_angle_to(global_direction, $Camera.global_transform.basis.x)) * SPEED
		#velocity = direction * SPEED
		#velocity = global_position.direction_to($Dir.global_position).normalized() * direction * SPEED
		#print(velocity)
		
		# get wall orientation
		wall_normal = get_wall_normal()
		#print(wall_normal)
		inertia = -wall_normal
		#inertia = (previous_position - position).normalized() #for later
	else:
		#if global_direction.length() == 1.0:
			#$Dir.position = global_direction
		# intertial movement
		velocity = inertia * SPEED
		pass
	
	
	
	# apply whatever rotation
	# handle rotation
	### THIS IS THE GOOD ONE
	if global_direction.length() == 1.0:
		#last_global_direction = $Dir.global_transform.origin
		target_basis = transform.looking_at($Dir.global_transform.origin, wall_normal).basis.orthonormalized()
		#target_basis = transform.looking_at(frontOrientation, wall_normal).basis.orthonormalized()
	else:
		target_basis = _basis_from_normal(wall_normal)
		pass
	
	#target_basis = transform.looking_at(last_global_direction, wall_normal).basis.orthonormalized()
	#target_basis = _basis_from_normal(wall_normal)
	transform.basis = lerp(transform.basis, target_basis, SPEED * delta).orthonormalized()
	
	# update variables
	upOrientation = global_position.direction_to($Up.global_transform.origin).normalized()
	frontOrientation = global_position.direction_to($Front.global_transform.origin).normalized()
	rightOrientation = global_position.direction_to($Right.global_transform.origin).normalized()
	
	# apply whatever movement was calculated
	set_up_direction(wall_normal)
	previous_position = position
	#translate((inertia + direction) * SPEED * delta)
	move_and_slide()
	#rotate_object_local(Vector3.UP, -input_dir.x * rotation_speed * delta)
	
	#print("direction: " + str(direction))
	#print("x: " + str(transform.basis.x))
	#print("z: " + str(transform.basis.z))
	
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
