extends Node

var sensibility_modifier: float = 1.0
var cookies_found: int = 0
var shadows_on: bool = false

signal shadows_changed(new_state: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_shadows_state() -> bool:
	return shadows_on

func set_shadows_state(new_state: bool) -> void:
	shadows_on = new_state
	pass
