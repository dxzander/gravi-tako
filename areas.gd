extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func colorize(n: int) -> void:
	#get_parent().get_parent().get_node("Overlays/Color Overlay").material.set_shader_parameter("color", n)
	pass

func _on_start_body_entered(body):
	#colorize(0)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Hub -"
	pass # Replace with function body.

func _on_up_body_entered(body):
	#colorize(1)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Pool -"
	pass # Replace with function body.

func _on_down_body_entered(body):
	#colorize(2)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Maze -"
	pass # Replace with function body.

func _on_left_body_entered(body):
	#colorize(3)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Orbitorium -"
	pass # Replace with function body.

func _on_right_body_entered(body):
	#colorize(4)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Mad Gismo -"
	pass # Replace with function body.

func _on_front_body_entered(body):
	#colorize(5)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Observatory -"
	pass # Replace with function body.

func _on_back_body_entered(body):
	#colorize(6)
	get_parent().get_parent().get_node("Overlays/CenterContainer/Label").text = "- Torus -"
	pass # Replace with function body.

func _on_halls_body_entered(body):
	#colorize(7)
	pass # Replace with function body.
