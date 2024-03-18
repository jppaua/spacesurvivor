extends CharacterBody2D

const SPEED = 0.0
@onready var timer = $Timer

func _ready():
	timer.start()

func _physics_process(delta):
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * SPEED
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("solid_tile"):
		queue_free()
	
