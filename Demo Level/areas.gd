extends Node3D

func _on_start_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Hub -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_up_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Pool -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_down_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Maze -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_left_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Orbitorium -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_right_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Mad Gismo -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_front_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Observatory -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_back_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".show()
		%"Zone Name".text = "- Torus -"
		%"Zone Name Timer".start()
	pass # Replace with function body.

func _on_halls_body_entered(body) -> void:
	if body.is_in_group("player"):
		%"Zone Name".hide()
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	%"Zone Name".hide()
	pass # Replace with function body.
