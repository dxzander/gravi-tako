extends Sprite3D

@export var player = CharacterBody3D

func _physics_process(_delta):
	global_transform = player.global_transform
