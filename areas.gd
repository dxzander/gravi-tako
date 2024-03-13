extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func colorize(n: int) -> void:
	get_parent().get_parent().get_node("Overlays/Color Overlay").material.set_shader_parameter("color", n)
	pass

func _on_start_body_entered(body):
	#colorize(0)
	pass # Replace with function body.

func _on_up_body_entered(body):
	#colorize(1)
	pass # Replace with function body.

func _on_down_body_entered(body):
	#colorize(2)
	pass # Replace with function body.

func _on_left_body_entered(body):
	#colorize(3)
	pass # Replace with function body.

func _on_right_body_entered(body):
	#colorize(4)
	pass # Replace with function body.

func _on_front_body_entered(body):
	#colorize(5)
	pass # Replace with function body.

func _on_back_body_entered(body):
	#colorize(6)
	pass # Replace with function body.

func _on_halls_body_entered(body):
	#colorize(7)
	pass # Replace with function body.
