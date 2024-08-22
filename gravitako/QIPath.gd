extends Node3D

var SPEED: float = 50.0
var counter: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$PathFollow3D.set_progress_ratio(remap(sin(deg_to_rad(counter)), -1, 1, 0, 1))
	counter += 1.0 * SPEED * delta
	pass
