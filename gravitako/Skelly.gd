extends Skeleton3D

@export var target_skelly: Skeleton3D

@export var lin_spring_stiff: float = 1200.0
@export var lin_spring_damp: float = 40.0

@export var angle_spring_stiff: float = 4000.0
@export var angle_spring_damp: float = 80.0

var physics_bones

func _ready():
	physical_bones_start_simulation()
	#physics_bones = get_children().filter(func(x): return x is PhysicalBone3D)
	pass

func _process(delta):
	pass

func _physics_process(delta):
	#for b in physics_bones:
		#var target_transform: Transform3D = target_skelly.global_transform * target_skelly.get_bone_global_pose(b.get_bone_id())
		#var current_transform: Transform3D = global_transform * target_skelly.get_bone_global_pose(b.get_bone_id())
		#
		#var position_difference: Vector3 = target_transform.origin - current_transform.origin
		#var force: Vector3 = hookes_law(position_difference, b.linear_velocity, lin_spring_stiff, lin_spring_damp)
		#
		#b.linear_velocity += (force * delta)
		#
		#var rotation_difference: Basis = (target_transform.basis * current_transform.basis.inverse())
		#var torque = hookes_law(rotation_difference.get_euler(), b.angular_velocity, angle_spring_stiff, angle_spring_damp)
		#
		#b.angular_velocity += (torque * delta)
	pass

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)
