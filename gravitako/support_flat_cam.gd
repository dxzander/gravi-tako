extends Camera3D

var previous_target_transform: Transform3D

@onready var gravitako = self.get_parent().get_parent().get_parent()
#@onready var cam = get_node("Camera")

func _physics_process(_delta):
	if previous_target_transform != gravitako.global_transform:
		global_transform = gravitako.global_transform
		translate_object_local(Vector3(0.0, 0.0, 12.0))
		#rotation = cam.rotation
