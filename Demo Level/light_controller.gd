extends OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow_enabled = Globals.get_shadows_state()
	Globals.shadows_changed.connect(_on_shadows_changed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shadows_changed(new_state) -> void:
	shadow_enabled = new_state
	pass
