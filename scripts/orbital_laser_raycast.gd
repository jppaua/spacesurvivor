extends Node2D

var damage = 0
var printed = false
var knockback = Vector2(500, -500)
var collision_point = Vector2(0,0)
var enemies_in_range = []
@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var impact = $impact
@onready var lifetime = $lifetime


func _ready():
	line.clear_points()
	var ray_top = get_global_mouse_position()
	ray_top.y -= 5000
	global_position = ray_top
	rotation_degrees = 0
	
	

func _process(delta):
	if !ray_cast.is_colliding():
		return
	collision_point = ray_cast.get_collision_point()
	line.clear_points()
	line.add_point(line.to_local(global_position))
	line.add_point(line.to_local(collision_point))
	impact.global_position = collision_point + Vector2(0, -11)
	
	if !enemies_in_range.is_empty():
		for enemy in enemies_in_range:
			enemy.take_damage(damage)
			enemy.take_knockback(self, knockback)

func _on_lifetime_timeout():
	queue_free()

func _on_hitbox_body_entered(body):
	enemies_in_range.append(body)

func _on_hitbox_body_exited(body):
	enemies_in_range.erase(body)
