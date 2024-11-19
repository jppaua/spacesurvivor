extends CharacterBody2D

var speed = 750.0
var damage = 0
var enemiesInRange = []
var knockback = Vector2(1200, -1200)
var has_exploded = false
var grenade_explosion = preload("res://scenes/prefabs/meteor_explosion.tscn")
var rng = RandomNumberGenerator.new()
var direction = 0

@onready var sprite_2d = $Sprite2D

func _ready():
	sprite_2d.rotation = rng.randf_range(0, 360)
	var scale = rng.randf_range(-0.5, 1)
	sprite_2d.scale += Vector2(scale, scale)
	
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
		var particles1 = new_explosion_particles.get_node("explosion1")
		var particles2 = new_explosion_particles.get_node("explosion2")
		var particles3 = new_explosion_particles.get_node("explosion3")
		particles.emitting = true
		particles1.emitting = true
		particles2.emitting = true
		particles3.emitting = true
		await get_tree().create_timer(particles.lifetime+0.1).timeout
		new_explosion_particles.queue_free()
		queue_free()


func _on_explosion_hit_box_body_entered(body):
	if body.is_in_group("enemy"):
		enemiesInRange.append(body)

func _on_explosion_hit_box_body_exited(body):
	if body.is_in_group("enemy"):
		enemiesInRange.erase(body)
