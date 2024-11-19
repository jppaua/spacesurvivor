extends CharacterBody2D

var speed = 750.0
var damage = 0
var enemiesInRange = []
var knockback = Vector2(1200, -1200)
var has_exploded = false
var grenade_explosion = preload("res://scenes/prefabs/grenade_explosion.tscn")
var rng = RandomNumberGenerator.new()
var direction = 0

func _ready():
	var target = get_global_mouse_position()
	var x_offset = rng.randf_range(-1000.0, 1000.0)
	self.global_position = Vector2(target.x + x_offset, target.y - 1000)
	direction = (target - self.global_position).normalized()

func _physics_process(_delta):
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
	get_node("trail2").emitting = false
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


func _on_explosion_hit_box_body_entered(body):
	if body.is_in_group("enemy"):
		enemiesInRange.append(body)

func _on_explosion_hit_box_body_exited(body):
	if body.is_in_group("enemy"):
		enemiesInRange.erase(body)
