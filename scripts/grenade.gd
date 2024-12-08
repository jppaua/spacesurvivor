extends CharacterBody2D

var speed = 1300.0
var damage = 0
var enemiesInRange = []
var knockback = Vector2(600, -600)
var has_exploded = false
var grenade_explosion = preload("res://scenes/prefabs/grenade_explosion.tscn")
var explosionSFX = "res://audio/sfx/explosion.wav"

func _physics_process(_delta):
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()
	
	
func _on_area_2d_body_entered(body):
	if has_exploded:
		return
	has_exploded = true
	get_node("Sprite2D").visible = false
	get_node("trail").emitting = false
	speed = 0
	if body.is_in_group("solid_tile") or body.is_in_group("enemy"):
		for enemy in enemiesInRange:
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage)
			if enemy.has_method("take_knockback"):
				enemy.take_knockback(self, knockback)
		
		var new_explosion_particles = grenade_explosion.instantiate()
		add_child(new_explosion_particles)
		var particles = new_explosion_particles.get_node("explosion")
		particles.emitting = true
		await get_tree().create_timer(particles.lifetime+0.1).timeout
		new_explosion_particles.queue_free()
		queue_free()
	SoundManager.play(explosionSFX)


func _on_explosion_hit_box_body_entered(body):
	if body.is_in_group("enemy"):
		enemiesInRange.append(body)

func _on_explosion_hit_box_body_exited(body):
	if body.is_in_group("enemy"):
		enemiesInRange.erase(body)
