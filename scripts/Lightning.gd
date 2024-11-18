extends Node2D

var damage = 0
var knockback = Vector2(200, -200)
var enemies_in_range = []

@onready var line = $Line2D
@onready var impact_particles = $impactParticles
@onready var root_particles = $rootParticles
@onready var hitbox = $hitbox
@onready var damage_timer = $damageTimer

func _process(delta):
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		queue_free()
	
	root_particles.global_position = Global.player_node.global_position
	impact_particles.global_position = get_global_mouse_position()
	hitbox.global_position = get_global_mouse_position()
	
	var root_pos = Global.player_node.global_position
	var target_pos = get_global_mouse_position()
	line.set_point_position(0, line.to_local(root_pos))
	line.set_point_position(1, line.to_local(target_pos))


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)


func _on_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)


func _on_damage_timer_timeout():
	for enemy in enemies_in_range:
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
		if enemy.has_method("take_knockback"):
			enemy.take_knockback(self, knockback)
