extends CharacterBody2D

var speed = 700.0
var damage = 0
var enemiesInRange = []
var knockback = Vector2(600, -600)
var has_exploded = false
var grenade_explosion = preload("res://scenes/prefabs/seeking_grenade_explosion.tscn")
var max_length = 10
var direction = 0
var twirl_frequency = 25.0
var twirl_time = 0.0
var twirl_time_2 = 11.0
var twirl_time_3 = 7.0
var radius

@onready var trail_3 = $trail3
@onready var trail_2 = $trail2
@onready var trail = $trail
@onready var sprite_2d = $Sprite2D

func _ready():
	trail_3.clear_points()
	trail_2.clear_points()
	trail.clear_points()
	radius = sprite_2d.texture.get_size().x * 0.5
	var target = get_global_mouse_position()
	direction = (target - self.global_position).normalized()

func _physics_process(delta):
	
	twirl_time += delta * twirl_frequency
	twirl_time_2 += delta * twirl_frequency
	twirl_time_3 += delta * twirl_frequency
	var twirl_offset = Vector2(cos(twirl_time) * radius, sin(twirl_time) * radius)
	var twirl_offset_2 = Vector2(cos(twirl_time_2) * radius, sin(twirl_time_2) * radius)
	var twirl_offset_3 = Vector2(cos(twirl_time_3) * radius, sin(twirl_time_3) * radius)
	trail.add_point((self.global_position - radius * direction) - twirl_offset)
	trail_2.add_point((self.global_position - radius * direction) - twirl_offset_2)
	trail_3.add_point((self.global_position - radius * direction) - twirl_offset_3)
	
	if trail.points.size() > max_length:
		trail.remove_point(0)
	if trail_2.points.size() > max_length:
		trail_2.remove_point(0)
	if trail_3.points.size() > max_length:
		trail_3.remove_point(0)
	
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()
	
func _on_area_2d_body_entered(body):
	if has_exploded:
		return
	has_exploded = true
	get_node("Sprite2D").visible = false
	trail.clear_points()
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
