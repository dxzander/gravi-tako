extends CharacterBody3D

@export var SPEED := 10.0
@export var rotation_speed := 4.0
const JUMP_DIR := Vector3.UP

var upOrientation := Vector3.UP
var frontOrientation := Vector3.FORWARD
var rightOrientation := Vector3.RIGHT
var wall_normal := Vector3.UP
var target_basis := Basis()
var inertia := Vector3.DOWN

@onready var previous_position = position
@onready var fl_leg = $Marks/MarkFL
@onready var fr_leg = $Marks/MarkFR
@onready var bl_leg = $Marks/MarkBL
@onready var br_leg = $Marks/MarkBR

func _on_ready():
	#set_floor_block_on_wall_enabled(false)
	pass

func _physics_process(delta):
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	
	# my attempt
	if Input.is_action_just_pressed("ui_accept") and is_on_wall():
		# jump takes priority
		velocity = JUMP_DIR * SPEED
		inertia = JUMP_DIR
	elif is_on_wall():
		# movement while "grounded"
		# get wall orientation
		wall_normal = get_wall_normal()
		inertia = -wall_normal
		#inertia = (previous_position - position).normalized() #for later
		
		# align to wall
		#if is_close_enough(abs(transform.basis.z), abs(wall_normal)):
			#target_basis = transform.basis.looking_at(upOrientation, frontOrientation)
			##target_basis = transform.rotated_local(Vector3.RIGHT, transform.basis.z.signed_angle_to(Vector3.UP, Vector3.RIGHT)).basis
			#pass
		#elif is_close_enough(abs(transform.basis.x), abs(wall_normal)):
			##target_basis = transform.rotated_local(Vector3.FORWARD, PI / 4).basis
			#pass
		#else:
			#target_basis = _basis_from_normal(wall_normal)
		var angle_to_normal = Vector3.UP.angle_to(wall_normal)
		print(angle_to_normal)
		if angle_to_normal < PI / 2:
			target_basis = _basis_from_normal(wall_normal)
			transform.basis = lerp(transform.basis.orthonormalized(), target_basis, SPEED * delta).orthonormalized()
		else:
			print("angle greater than pi / 2!")
		get_up()
		#transform.basis = target_basis
		#transform = transform.orthonormalized()
		
		# get input
		var x_dir = Input.get_axis("ui_right", "ui_left")
		var y_dir = Input.get_axis("ui_up", "ui_down")
		
		# transform input based on camera
		var direction = ($Camera.global_transform.basis * Vector3(0, 0, y_dir)).normalized()
		velocity = direction * SPEED
		
		# rotate
		rotate_object_local(Vector3.UP, x_dir * rotation_speed * delta)
	else:
		# intertial movement
		velocity = inertia * SPEED
	
	previous_position = position
	move_and_slide()
	pass

func get_up():
	upOrientation = global_position.direction_to($Up.global_transform.origin).normalized()
	return upOrientation

func get_front():
	frontOrientation = global_position.direction_to($Front.global_transform.origin).normalized()
	return frontOrientation

func get_right():
	rightOrientation = global_position.direction_to($Right.global_transform.origin).normalized()
	return rightOrientation

#func _handle_movement(delta):
	#var x_dir = Input.get_axis("ui_right", "ui_left")
	#var y_dir = Input.get_axis("ui_up", "ui_down")
	#
	##var direction = (Vector3(0, 0, y_dir)).normalized()
	##translate_object_local(direction * SPEED * delta)
	#
	#var direction = ($Camera.global_transform.basis * Vector3(0, 0, y_dir)).normalized()
	##if direction:
		##velocity = direction * SPEED
	##else:
		##velocity.x = move_toward(velocity.x, 0, SPEED)
		##velocity.z = move_toward(velocity.z, 0, SPEED)
	#velocity = direction * SPEED
	#
	##print(direction)
	#
	##move_and_slide()
	#
	#rotate_object_local(Vector3.UP, x_dir * rotation_speed * delta)
	#pass

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
