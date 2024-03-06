extends CharacterBody3D

@export var SPEED = 10.0

@export var rotation_speed = 4.0
var upOrientation = Vector3(0.0, 1.0, 0.0)
var curOrientation = Vector3(0, 0, 0)
var tarOrientation = Vector3(0, 0, 0)
var lerOrientation = Vector3(0, 0, 0)

@onready var cl_leg = $Marks/MarkCL
@onready var cr_leg = $Marks/MarkCR
@onready var fl_leg = $Marks/MarkFL
@onready var fr_leg = $Marks/MarkFR
@onready var bl_leg = $Marks/MarkBL
@onready var br_leg = $Marks/MarkBR

@export var ground_offset: float = 0.5
var is_up_changing = false

func _on_ready():
	set_floor_block_on_wall_enabled(false)
	pass

func _physics_process(delta):
	get_up()
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	
	# method from video
	var plane1 = Plane(fl_leg.global_position, fr_leg.global_position, bl_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2 ).normalized()
	#print(upOrientation)
	
	var target_basis = _basis_from_normal(avg_normal)
	#if target_basis.is_equal_approx(transform.basis) and transform.basis.is_equal_approx(target_basis):
		#transform.basis = lerp(transform.basis, target_basis, SPEED * delta).orthonormalized()
		#is_up_changing = true
	#else:
		#is_up_changing = false
	transform.basis = lerp(transform.basis, target_basis, SPEED * delta).orthonormalized()
	print(is_up_changing)
	
	# adapting the method to my needs
	#print(get_wall_normal())
	#if is_on_wall():
		#var target_basis = _basis_from_normal(get_wall_normal())
		#print(get_wall_normal())
		#transform.basis = lerp(transform.basis, target_basis, SPEED * delta).orthonormalized()
		##look_at($Front.position, get_wall_normal())
		#pass
	
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, SPEED * delta)
	
	_handle_movement(delta)
	pass

func get_up():
	upOrientation = global_position.direction_to($Up.global_transform.origin)
	return upOrientation

func _handle_movement(delta):
	var x_dir = Input.get_axis("ui_right", "ui_left")
	var y_dir = Input.get_axis("ui_up", "ui_down")
	
	var direction = (Vector3(0, 0, y_dir)).normalized()
	translate_object_local(direction * SPEED * delta)
	
	#var direction = ($Camera.global_transform.basis * Vector3(x_dir, 0, y_dir)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	#
	#move_and_slide()
	
	rotate_object_local(Vector3.UP, x_dir * rotation_speed * delta)
	pass

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	return result
