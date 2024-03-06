extends CharacterBody2D


const LAND_SPEED = 350.0
const AIR_SPEED = 120.0
const JUMP_VELOCITY = -850.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and is_on_floor():
		velocity.x = direction * LAND_SPEED
	else:
		if direction and not is_on_floor():
			if abs(velocity.x) <= AIR_SPEED:
				velocity.x = direction * AIR_SPEED

	if not is_on_floor():
		velocity.x=move_toward(velocity.x, 0, 1)
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
