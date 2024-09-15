extends CharacterBody2D

signal health_depleted


var speed = PlayerStats.speed
var jump_velocity = PlayerStats.jump_velocity
var gravity_damping = PlayerStats.gravity_damping
var air_speed_increment = PlayerStats.air_speed_increment
var max_health = PlayerStats.max_health
var health = PlayerStats.health
var gravity = PlayerStats.gravity
var current_item = null
var current_hotbar_index = -1
var num_killed = 0

@onready var player_parent = $PlayerParent
@onready var timer = $Timer

@onready var left_arm_parent = $PlayerParent/LeftArmParent
@onready var left_hand_sprite = $PlayerParent/LeftArmParent/LeftHandParent/LeftHandSprite
@onready var left_barrel = $PlayerParent/LeftArmParent/LeftHandParent/LeftBarrel
@onready var body_sprite = $PlayerParent/BodySprite

@onready var right_arm_parent = $PlayerParent/RightArmParent
@onready var right_hand_sprite = $PlayerParent/RightArmParent/RightHandParent/RightHandSprite
@onready var right_barrel = $PlayerParent/RightArmParent/RightHandParent/RightBarrel

@onready var inventory_ui = $InventoryUI
@onready var fps_label = $FpsUI/Label
@onready var global_position_label = $GlobalPosUI/GlobalPosition
@onready var progress_bar = $PlayerInfo/ProgressBar
@onready var game_over = $GameOver
@onready var game_won = $GameWon

@onready var hurt_box = $HurtBox

@onready var crafting_ui = $CraftingUI

func _ready():
	#hooks up player to inventory
	Global.set_player_reference(self)
	progress_bar.max_value = max_health
	progress_bar.value = health  

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
	if current_item != null and current_item["type"] == "firearm":
		if current_item["is_full_auto"]:
			if Input.is_action_pressed("primary_action") and timer.time_left == 0:
				ItemFunctions.primary_action(current_item)
				timer.wait_time = current_item["rate_of_fire"]
				timer.start()
		else:
			if Input.is_action_just_pressed("primary_action") and current_item != null and timer.time_left == 0:
				ItemFunctions.primary_action(current_item)
				timer.wait_time = current_item["rate_of_fire"]
				timer.start()
<<<<<<< HEAD

=======
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
	move_and_slide()

func _input(event):
	set_hand_sprites()
	if current_item != null and event.is_action_pressed("primary_action") and false:
		ItemFunctions.primary_action(current_item)
	
	if inventory_ui.visible:
		if event.is_action_pressed("open_inv") or event.is_action_pressed("ui_cancel"):
			inventory_ui.visible = false
	else:
		if event.is_action_pressed("open_inv"):
			inventory_ui.visible = true
	#Call for Crafting UI
	if event.is_action_pressed("Craft"):
		if crafting_ui.visible:
			crafting_ui.visible = false
		else:
			crafting_ui.visible = true

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
			right_hand_sprite.offset = Vector2(current_item["x_offset"], current_item["y_offset"])
			right_hand_sprite.texture = current_item["texture"]
			right_barrel.transform.origin = Vector2(current_item["x_barrel"], current_item["y_barrel"])
			left_hand_sprite.offset = right_hand_sprite.offset
			left_hand_sprite.texture = right_hand_sprite.texture
			left_barrel.transform.origin = Vector2(current_item["x_barrel"], current_item["y_barrel"])
			
		else:
			right_hand_sprite.offset = Vector2(current_item["x_offset"], current_item["y_offset"])
			right_hand_sprite.texture = current_item["texture"]
			if current_item.has("x_barrel"):
				right_barrel.transform.origin = Vector2(current_item["x_barrel"], current_item["y_barrel"])
			else:
				right_barrel.transform.origin = Vector2(0, 0)
				left_barrel.transform.origin = Vector2(0, 0)
			left_hand_sprite.texture = null
	else:
		right_hand_sprite.texture = null
		left_hand_sprite.texture = null
		right_barrel.transform.origin = Vector2(0,0)
		left_barrel.transform.origin = Vector2(0,0)

#if mouse is to the left of the player, turn left and vice versa
func orient_player(mouse_position):
	if mouse_position.x > player_parent.global_position.x:
		player_parent.scale.x = 1
	else:
		player_parent.scale.x = -1

func handle_movement(direction, delta):
	#Controls air movement
	#Applies gravity, increases speed while in air in steps (up to maximum speed) for smoother movement
	if abs(velocity.x) > 1:
		body_sprite.animation = "running"
	else:
		body_sprite.animation = "default"
	
	if not is_on_floor():
		body_sprite.animation = "jumping"
		velocity.y += gravity * delta
		if direction * velocity.x < 0:
			velocity.x += direction * air_speed_increment
		else:
			if abs(velocity.x) < speed:
				velocity.x += direction * air_speed_increment
	#decreases speed rapidly when not holding direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	#Allows user to jump only while on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	#Applies maximum speed to user if they move while on the ground (unlike air movement)
	if direction and is_on_floor():
		velocity.x = direction * speed
		
	#Allows for variable jump height, letting go of jump causes you to decelerate based on GRAVITY_DAMPING
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= gravity_damping

func orient_player_arms(mouse_position):
	#makes the arms point towards the mouse, I barely understand this code am Im the guy who wrote it, whatever, it works.
	var angle_left = ((((mouse_position - left_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	var angle_right = ((((mouse_position - right_arm_parent.global_position).normalized()) * player_parent.scale.x).angle()) * player_parent.scale.x
	left_arm_parent.rotation = angle_left
	right_arm_parent.rotation = angle_right

func take_damage():
	health -= 1
	progress_bar.value = health
	if health <= 0:
		health_depleted.emit()


func _on_health_depleted():
	game_over.visible = true
	get_tree().paused = true


func _on_reset_pressed():
	game_over.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world/BigMap.tscn")
	

func _on_replay_pressed():
	game_won.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world/BigMap.tscn")
