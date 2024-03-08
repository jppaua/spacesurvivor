extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -850.0
const GRAVITY_DAMPING = 0.5
const AIR_SPEED_INCREMENT = 25
var isLeft = false
#var gravity = 1000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D


func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if direction * velocity.x < 0:
			velocity.x += direction * AIR_SPEED_INCREMENT
		else:
			if abs(velocity.x) < SPEED:
				velocity.x += direction * AIR_SPEED_INCREMENT

	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= GRAVITY_DAMPING
		
	move_and_slide()
	
	if velocity.x < 0:
		isLeft = true
	else:
		if velocity.x > 0:
			isLeft = false
	sprite_2d.flip_h = isLeft
