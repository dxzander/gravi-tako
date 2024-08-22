extends OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow_enabled = Globals.shadows_on
	Globals.shadows_changed.connect(_on_shadows_changed)
	pass # Replace with function body.

func _on_shadows_changed(new_state) -> void:
	shadow_enabled = new_state
	pass
