extends CharacterBody2D


class_name FrogEnemy


const SPEED = 300
const GRAVITY = 900
const MAX_DISTANCE = 100

@onready var hp = $EnemyInfo/HP
@onready var damage_numbers_origin = $DamageNumbersOrigin

var is_frog_chase: bool = true
var knockback_force = -20
var dir: Vector2


var health = 20
var MAX_HEALTH = 20
var HEALTH_MIN = 0

var is_dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 15
var is_dealing_damage: bool = false
var is_roaming: bool = true

var player: CharacterBody2D
var player_in_area: bool = false
#var damage = 15
signal died


func ready():
	hp.MAX_HEALTH = MAX_HEALTH
	hp.value = MAX_HEALTH
	



func _process(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.x = 0
	Global.frogDamageAmount = damage_to_deal
	Global.frogDamageZone = $FrogDamageZone
	
	player = Global.player_node
	
	move(delta)
	handle_animation()
	move_and_slide()



func move(delta):
	if !is_dead:
		
		if !is_frog_chase:
			velocity += dir * SPEED * delta
			is_roaming = true
		elif is_frog_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * SPEED
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
	elif is_dead:
		velocity.x = 0
		



func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !is_dead and !taking_damage and !is_dealing_damage:
		animated_sprite.play("walk")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false
	elif !is_dead and taking_damage and !is_dealing_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif is_dead and is_roaming:
		is_roaming = false #essentially stops the loop
		animated_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		handle_death()
	elif !is_dead and is_dealing_damage:
		animated_sprite.play("attack")
		velocity.x = 0

func handle_death():
	self.queue_free()


func _on_timer_timeout():
	$DirectionTimer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT,Vector2.LEFT])
		velocity.x = 0 #cause if u dont its gonna slide weird

func choose(array):
	array.shuffle()
	return array.front()


#func _on_frog_hit_box_area_entered(body):
	#if body.is_in_group("Player"):
		#print("Player in enemy")


func take_damage(damage):
	if is_dead:
		return
	health -= damage
	hp.value = health
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position)
	
	if health <= 0:
		is_dead = true
		player.num_killed += 1
		get_node("EnemyInfo").visible = false
		self.collision_layer &= ~4
		emit_signal("died",self)
		SignalBus.give_exp.emit()


func _on_frog_damage_zone_body_entered(body):
	if body.is_in_group("solid_tile") or body.is_in_group("Player"):
		if body.has_method("take_damage"):
			is_dealing_damage = true
			body.take_damage(damage_to_deal)
			await get_tree().create_timer(1.0).timeout
			is_dealing_damage = false


