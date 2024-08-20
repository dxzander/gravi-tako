extends Area3D

signal tako_eated_me

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_body_entered(body):
	if body.name == 'gravitako':
		tako_eated_me.emit()
		$Galleta.hide()
		$AnimatedSprite3D.show()
		$AnimatedSprite3D.play("default")
	pass # Replace with function body.


func _on_animated_sprite_3d_animation_finished():
	self.queue_free()
	pass # Replace with function body.
