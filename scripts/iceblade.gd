extends CharacterBody2D

const SPEED = 850.0
var damage = 0
var enemies_in_range = []
var knockback = Vector2(300, -200)
var enemy_found = false
var enemy_pos = null
var distance = INF
var rotation_speed = 17
var direction_found = false

@onready var idle_timer = $idleTimer

func _ready():
	self.global_position = get_global_mouse_position()

func _physics_process(_delta):
	if !enemy_found:
		for enemy in enemies_in_range:
			var new_distance = self.global_position.distance_to(enemy.global_position)
			enemy_pos = enemy_pos if new_distance > distance else enemy.global_position
			distance = min(distance, new_distance)
			enemy_found = true if enemy_pos else false
	
	if idle_timer.time_left != 0 or !enemy_pos:
		self.rotation += rotation_speed * _delta
		return
		
	var direction = 0
	if enemy_pos and !direction_found:
		direction = (enemy_pos - self.global_position).normalized()
		self.rotation = direction.angle()
		velocity = direction * SPEED
		direction_found = true
	
	move_and_slide()

func _on_timer_timeout():
	queue_free()
	
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("solid_tile") or body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("take_knockback"):
			body.take_knockback(self, knockback)
		queue_free()


func _on_vision_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)

func _on_vision_area_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)
