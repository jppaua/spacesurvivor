extends CharacterBody2D

const SPEED = 1300.0
@onready var timer = $Timer

func _ready():
	timer.start()

func _physics_process(delta):
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * SPEED
	move_and_slide()

func _on_timer_timeout():
	queue_free()
