extends Node3D

@export var SPEED = 10.0

@export var rotation_speed = 4.0
var upOrientation = Vector3(0.0, 1.0, 0.0)
var curOrientation = Vector3(0, 0, 0)
var tarOrientation = Vector3(0, 0, 0)
var lerOrientation = Vector3(0, 0, 0)

@export var ground_offset: float = 0.5

@onready var cl_leg = $Marks/MarkCL
@onready var cr_leg = $Marks/MarkCR
@onready var fl_leg = $Marks/MarkFL
@onready var fr_leg = $Marks/MarkFR
@onready var bl_leg = $Marks/MarkBL
@onready var br_leg = $Marks/MarkBR

func _on_ready():
	pass

func _physics_process(delta):
	#rotate(Vector3(0.0, 0.0, 1.0), 0.01)
	
	var plane1 = Plane(fl_leg.global_position, fr_leg.global_position, br_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, fl_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2 ).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, SPEED * delta).orthonormalized()
	
	_handle_movement(delta)
	pass

func get_up():
	upOrientation = global_position.direction_to($Up.global_transform.origin)
	return upOrientation

func _handle_movement(delta):
	get_up()
	
	var x_dir = Input.get_axis("ui_right", "ui_left")
	var y_dir = Input.get_axis("ui_up", "ui_down")
	#var direction = ($Camera.global_transform.basis * Vector3(x_dir, 0, y_dir)).normalized()
	var direction = (Vector3(x_dir, 0, y_dir)).normalized()
	translate(direction * SPEED * delta)
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	#
	#move_and_slide()
	
	rotate_object_local(Vector3.UP, x_dir * rotation_speed * delta)

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
