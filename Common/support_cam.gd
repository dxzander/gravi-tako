extends Camera3D

@export var player = Node3D

func _physics_process(delta):
	global_transform = player.get_cam_global_transform()
	pass
