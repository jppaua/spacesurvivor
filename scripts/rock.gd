extends CharacterBody2D

const SPEED = 400
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_position = Global.player_node.global_position
@onready var projectile_position = global_position

func _ready():
	var direction = 0
	var displacement = player_position - projectile_position
	var air_time = abs(displacement.x) / SPEED
	var velocity_y = (-0.5 * gravity * air_time) + (displacement.y * 2.0)
	
	if player_position.x > projectile_position.x:
		direction = 1
	else:
		direction = -1
	
	velocity = Vector2(SPEED * direction, velocity_y)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += (gravity * delta)
	move_and_slide()

func _on_timer_timeout():
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("solid_tile") or body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
