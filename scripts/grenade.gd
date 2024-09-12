extends CharacterBody2D

const SPEED = 1300.0

func _physics_process(delta):
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * SPEED
	move_and_slide()

func _on_timer_timeout():
	queue_free()
	
	
func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("solid_tile") or body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
