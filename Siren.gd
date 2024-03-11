extends OmniLight3D

var time: float = 0.0
var time_inc: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light_energy = sin(time * delta)
	#print(light_energy)
	time += time_inc
	pass
