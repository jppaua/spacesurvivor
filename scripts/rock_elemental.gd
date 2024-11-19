extends CharacterBody2D


const SPEED =300
const JUMP_VELOCITY = -700.0
const MIN_DISTANCE = 300
const MAX_DISTANCE = 450
var air_speed_increment = 25
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 10
var knockbackable = true
var can_move = true
var health = max_health
var distance
var status = "CHASING"
var player
var HitParticles = preload("res://scenes/prefabs/hit_particle.tscn")
signal died
var is_dead: bool = false

@onready var attack_timer = $rock_elemental_parent/Timer
@onready var hp = $EnemyInfo/HP
@onready var status_label = $EnemyInfo/status
@onready var enemy_position = $EnemyInfo/position
@onready var rock_elemental_parent = $rock_elemental_parent
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var knockback_timer = $rock_elemental_parent/knockbackTimer
@onready var _stun_timer = $rock_elemental_parent/stunTimer

@onready var navAgent = $NavigationAgent2D as NavigationAgent2D

func _ready():
	player = Global.player_node
	hp.max_value = max_health
	hp.value = max_health
	make_path()

func _physics_process(delta):
	navAgent.get_next_path_position()
	
	if player.global_position.x > global_position.x:
		rock_elemental_parent.scale.x = 1
	else:
		rock_elemental_parent.scale.x = -1
	
	var direction = to_local(navAgent.get_next_path_position()).normalized()
	
	if can_move:
		velocity.x = round(direction.x) * SPEED
	
	if status == "ATTACKING" and attack_timer.time_left == 0 or status == "RETREATING" and attack_timer.time_left == 0:
		attack()
		attack_timer.wait_time = 2
		attack_timer.start()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if direction.x * velocity.x < 0:
			velocity.x += direction.x * air_speed_increment
		else:
			if abs(velocity.x) < SPEED:
				velocity.x += direction.x * air_speed_increment
	#decreases speed rapidly when not holding direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	if(-0.5 > direction.y and is_on_floor() and abs(direction.x) > 0.01 ):
		jump()
	
	enemy_position.text = str(global_position)
	status_label.text = status
	move_and_slide()

func attack():
	var projectile = load("res://scenes/prefabs/rock.tscn")
	var projectile_instance = projectile.instantiate()
	var m_scale = Global.player_node.get_node("PlayerParent").scale
	projectile_instance.global_position = global_position
	projectile_instance.scale = m_scale
	get_tree().current_scene.add_child(projectile_instance)

func take_knockback(projectile, knockback):
	if(knockbackable):
		if projectile.position.x > position.x:
			knockback.x *= -1
		
		velocity = knockback
		knockback_timer.wait_time = 0.3
		knockback_timer.start()
		knockbackable = false
		can_move = false
		await knockback_timer.timeout
		knockbackable = true
		can_move = true

func take_damage(damage):
	if is_dead:
		return
	health -= damage
	hp.value = health
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position)
	
	if health <= 0:
		is_dead = true
		deathParticle()
		player.num_killed += 1
		get_node("rock_elemental_parent").visible = false
		get_node("EnemyInfo").visible = false
		self.collision_layer &= ~4
		await get_tree().create_timer(0.5).timeout
		emit_signal("died",self)
		SignalBus.give_exp.emit()
		queue_free()

func deathParticle():
	get_node("deathParticle").emitting = true

#For later use probably
func summonParticle():
	var new_hit_particles = HitParticles.instantiate()
	add_child(new_hit_particles)
	var particles = new_hit_particles.get_node("hitParticles")
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	new_hit_particles.queue_free()

func make_path():
	distance = global_position.distance_to(player.global_position)
	if distance >= MAX_DISTANCE:
		status = "CHASING"
		navAgent.target_position = player.global_position
	elif distance < MIN_DISTANCE: 
		status = "RETREATING"
		if player.global_position.x > global_position.x:
			navAgent.target_position = global_position + Vector2(50,0) * -1
		else:
			navAgent.target_position = global_position + Vector2(50,0)
	else: 
		status = "ATTACKING"

func jump(jump_size = JUMP_VELOCITY):
	velocity.y = jump_size

#Use later to allow enemies to make large jumps
func _on_navigation_agent_2d_link_reached(details):
	pass

func nav_timer_timeout():
	make_path()
