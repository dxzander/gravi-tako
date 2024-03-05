extends Node3D

@export var offset: float = 20.0

@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position

func _process(delta):
	var parent_current_position = parent.global_position
	var velocity = parent_current_position - previous_position
	global_position = parent_current_position + velocity * offset
	
	previous_position = parent_current_position
	pass