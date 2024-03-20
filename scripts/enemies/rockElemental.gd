extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

@export var speed = 50
@export var nav_agent: NavigationAgent2D

var target_node = null
var home_pos = Vector2.ZERO

func _ready():
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	
func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		return
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	
	move_and_slide()

func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos
	



func _on_recalculate_timer_timeout():
	recalc_path()


func _on_aggro_range_area_entered(area):
	target_node = area.owner


func _on_de_aggro_range_area_exited(area):
	if area.owner == target_node:
		target_node = null
