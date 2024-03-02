extends CharacterBody3D

const SPEED = 1.0

var hoverStrengthX = 1.0
var hoverStrengthY = 1.0
var lemniscateTimeCounter = 0.0
var lemniscateTimeCounterRate = 0.04
var hoverVector = Vector2()
var direction = Vector3()

var rotation_speed = 0.05
var curTar = position
var realTar = Vector3(0, 0, 0)
var lerpedTar = Vector3(0, 0, 0)

func _physics_process(delta):
	# set new up
	set_up_direction(get_parent().get_parent().get_parent().get_up())
	
	# set target
	realTar = $"../../../Reticle/Reticle3D".global_transform.origin
	
	# lemniscate hover animation
	lemniscateTimeCounter = lemniscateTimeCounter + lemniscateTimeCounterRate
	hoverVector = Vector2((cos(lemniscateTimeCounter)*hoverStrengthX),(sin(2*lemniscateTimeCounter)/2)*hoverStrengthY)
	direction = Vector3(hoverVector.x, hoverVector.y, 0.0)
	
	# shoot towards target
	if Input.is_action_pressed("ui_accept") and name == 'HandR':
		velocity.lerp(realTar, 100.0)
	if Input.is_action_pressed("ui_cancel") and name == 'HandL':
		velocity.lerp(realTar, 100.0)
	
	# apply movement
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = -direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	# point smoothly towards target
	lerpedTar = curTar.lerp(realTar, rotation_speed)
	look_at(lerpedTar, get_up_direction())
	curTar = lerpedTar
