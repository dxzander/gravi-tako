@tool extends OmniLight3D

var previous_shadows_state: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow_enabled = Globals.get_shadows_state()
	previous_shadows_state = Globals.get_shadows_state()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if previous_shadows_state != Globals.get_shadows_state():
		shadow_enabled = Globals.get_shadows_state()
		previous_shadows_state = Globals.get_shadows_state()
	pass
