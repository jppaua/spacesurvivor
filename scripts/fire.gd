extends CharacterBody2D

const SPEED = 1000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
@onready var player_position = Global.player_node.global_position
@onready var projectile_position = global_position

func _ready():
	var direction = projectile_position.direction_to(player_position)
	direction += Vector2(rng.randf_range(-0.5,0.5), rng.randf_range(-0.5,0.5))
	
	velocity = direction * SPEED

func _physics_process(delta):
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("solid_tile") or body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()