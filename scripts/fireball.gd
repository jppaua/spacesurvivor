extends CharacterBody2D

var speed = 850.0
var damage = 0
var turn_speed = 5.0
var knockback = Vector2(500, -500)
var has_tracked = false
var grenade_explosion = preload("res://scenes/prefabs/seeking_grenade_explosion.tscn")

func _physics_process(delta):
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		has_tracked = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !has_tracked:
		var mouse_position = get_global_mouse_position()
		var direction_to_mouse = (mouse_position - position).normalized()
		var target_rotation = direction_to_mouse.angle()
		rotation = lerp_angle(rotation, target_rotation, turn_speed * delta)
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()
	
	
func _on_area_2d_body_entered(body):
	get_node("trail").emitting = false
	speed = 0
	if body.is_in_group("solid_tile") or body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("take_knockback"):
			body.take_knockback(self, knockback)
		var new_explosion_particles = grenade_explosion.instantiate()
		add_child(new_explosion_particles)
		var particles = new_explosion_particles.get_node("explosion")
		particles.emitting = true
		await get_tree().create_timer(particles.lifetime+0.1).timeout
		new_explosion_particles.queue_free()
		queue_free()
