extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_space_cookie_tako_eated_me():
	Globals.cookies_found += 1
	%Cookies.set_text("Cookies: %d" % Globals.cookies_found)
	pass # Replace with function body.