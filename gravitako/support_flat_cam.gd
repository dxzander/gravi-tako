extends Node3D

@onready var cam = self.get_parent().get_parent().get_parent().get_node("Camera")

func _physics_process(_delta):
	global_transform = cam.global_transform
	rotation.x = deg_to_rad(0.0)
