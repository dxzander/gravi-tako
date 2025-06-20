extends Sprite3D

@onready var cam = self.get_parent().get_node("Camera")

func _physics_process(_delta):
	#global_transform = cam.global_transform
	rotation.y = deg_to_rad(snapped(rad_to_deg(cam.rotation.y), 22.5))
