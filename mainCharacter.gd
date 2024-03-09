extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -850.0
const GRAVITY_DAMPING = 0.5
const AIR_SPEED_INCREMENT = 25
#var gravity = 1000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_parent = $PlayerParent
@onready var left_arm_parent = $PlayerParent/LeftArmParent
@onready var right_arm_parent = $PlayerParent/RightArmParent



func _physics_process(delta):
	
	#-1 if holding left, 0 if no keys are pressed, 1 if holding right
	var direction = Input.get_axis("left", "right")
	var mouse_position = get_global_mouse_position()
	
	#if mouse is to the left of the player, turn left and vice versa
	if mouse_position.x > player_parent.global_position.x:
		player_parent.scale.x = 1
	else:
		player_parent.scale.x = -1
	
	#Controls air movement
	#Applies gravity, increases speed while in air in steps (up to maximum speed) for smoother movement
	if not is_on_floor():
		velocity.y += gravity * delta
		if direction * velocity.x < 0:
			velocity.x += direction * AIR_SPEED_INCREMENT
		else:
			if abs(velocity.x) < SPEED:
				velocity.x += direction * AIR_SPEED_INCREMENT
	
	#decreases speed rapidly when not holding direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	#Allows user to jump only while on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Applies maximum speed to user if they move while on the ground (unlike air movement)
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		
	#Allows for variable jump height, letting go of jump causes you to decelerate based on GRAVITY_DAMPING
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= GRAVITY_DAMPING
	
	#makes the arms point towards the mouse, I barely understand this code am Im the guy who wrote it, whatever, it works.
	var angle_left = ((((mouse_position - left_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	var angle_right = ((((mouse_position - right_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	left_arm_parent.rotation = angle_left
	right_arm_parent.rotation = angle_right
	
	
	move_and_slide()
