extends CharacterBody3D

const SPEED = 1.0

var hoverStrengthX = 0.5
var hoverStrengthY = 0.5
var lemniscateTimeCounter = 0.0
var lemniscateTimeCounterRate = 0.04
var hoverVector = Vector2()
var direction = Vector3()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	lemniscateTimeCounter = lemniscateTimeCounter + lemniscateTimeCounterRate
	hoverVector = Vector2((cos(lemniscateTimeCounter)*hoverStrengthX),(sin(2*lemniscateTimeCounter)/2)*hoverStrengthY)
	
	direction = Vector3(hoverVector.x, hoverVector.y, 0.0)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = -direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
