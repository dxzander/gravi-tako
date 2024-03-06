extends Marker3D

@export var step_target = Node3D
@export var adjacent_target = Node3D
@export var opposite_target = Node3D

@export var step_distance: float = 1.0
@export var tween_speed_x: float = 0.03
@export var tween_speed_y: float = 0.03

var is_stepping := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_stepping && !adjacent_target.is_stepping && abs(global_position.distance_to(step_target.global_position)) > step_distance:
		step()
		opposite_target.step()
	pass

func step():
	var tar_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, tween_speed_y)
	t.tween_property(self, "global_position", tar_pos, tween_speed_x)
	t.tween_callback(func(): is_stepping = false)
	pass
