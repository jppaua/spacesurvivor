extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -850.0
const GRAVITY_DAMPING = 0.5
const AIR_SPEED_INCREMENT = 25
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_item = null
var current_hotbar_index = -1

@onready var player_parent = $PlayerParent

@onready var left_arm_parent = $PlayerParent/LeftArmParent
@onready var left_hand_sprite = $PlayerParent/LeftArmParent/LeftHandParent/LeftHandSprite

@onready var right_arm_parent = $PlayerParent/RightArmParent
@onready var right_hand_sprite = $PlayerParent/RightArmParent/RightHandParent/RightHandSprite

@onready var inventory_ui = $InventoryUI
@onready var fps_label = $FpsUI/Label
@onready var global_position_label = $GlobalPosUI/GlobalPosition

func _ready():
	#hooks up player to inventory
	Global.set_player_reference(self)

func _physics_process(delta):
	#-1 if holding left, 0 if no keys are pressed, 1 if holding right
	var direction = Input.get_axis("left", "right")
	var mouse_position = get_global_mouse_position()
	
	#Sets Position and FPS labels for debuging purposes
	global_position_label.text = "[ " + str(round(player_parent.global_position.x*10)/10) + " , " + str(round(player_parent.global_position.y*10)/10) + " ]"
	fps_label.text = str(Engine.get_frames_per_second())
	
	
	orient_player(mouse_position)
	orient_player_arms(mouse_position)
	handle_movement(direction, delta)
	set_hand_sprites()
	move_and_slide()


func _input(event):
	if inventory_ui.visible:
		if event.is_action_pressed("open_inv") or event.is_action_pressed("ui_cancel"):
			inventory_ui.visible = false
	else:
		if event.is_action_pressed("open_inv"):
			inventory_ui.visible = true

#Sets the sprites of whatever the player is holding
func set_hand_sprites():
	if Input.is_action_just_pressed("select_hotbar_slot"):
		for i in range(48, 58):
			if Input.is_physical_key_pressed(i):
				current_hotbar_index = i-49
				break
	if Input.is_action_just_pressed("scroll_down_hotbar_slot"):
		if current_hotbar_index + 1 <= 8:
			current_hotbar_index += 1
		else:
			current_hotbar_index = 0
	if Input.is_action_just_pressed("scroll_up_hotbar_slot"):
		if current_hotbar_index - 1 >= 0:
			current_hotbar_index -= 1
		else:
			current_hotbar_index = 8
	if Input.is_action_just_pressed("unselect_hotbar_slot"):
		current_hotbar_index = -1
		
	current_item = Global.hotbar[current_hotbar_index]
	if current_item != null:
		if current_item["is_dual_wield"]:
			right_hand_sprite.offset.x = current_item["x_offset"]
			right_hand_sprite.offset.y = current_item["y_offset"]
			right_hand_sprite.texture = current_item["texture"]
			left_hand_sprite.offset = right_hand_sprite.offset
			left_hand_sprite.texture = right_hand_sprite.texture
		else:
			right_hand_sprite.offset.x = current_item["x_offset"]
			right_hand_sprite.offset.y = current_item["y_offset"]
			right_hand_sprite.texture = current_item["texture"]
			left_hand_sprite.texture = null
	else:
		right_hand_sprite.texture = null
		left_hand_sprite.texture = null

#if mouse is to the left of the player, turn left and vice versa
func orient_player(mouse_position):
	if mouse_position.x > player_parent.global_position.x:
		player_parent.scale.x = 1
	else:
		player_parent.scale.x = -1

func handle_movement(direction, delta):
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

func orient_player_arms(mouse_position):
	#makes the arms point towards the mouse, I barely understand this code am Im the guy who wrote it, whatever, it works.
	var angle_left = ((((mouse_position - left_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	var angle_right = ((((mouse_position - right_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	left_arm_parent.rotation = angle_left
	right_arm_parent.rotation = angle_right
















