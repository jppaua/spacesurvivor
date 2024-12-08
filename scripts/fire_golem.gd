extends CharacterBody2D

const SPEED = 260.0
const JUMP_VELOCITY = -700.0
const AOE_RANGE = 50.0  # Distance at which the enemy uses the AOE attack
var air_speed_increment = 25
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 999
var knockbackable = true
var health = max_health
var previous_x_position
var distance
var status = "CHASING"
var player
var HitParticles = preload("res://scenes/prefabs/hit_particle.tscn")
var AOE_PREFAB = preload("res://scenes/prefabs/aoe_attack.tscn") # Prefab for AOE attack

@onready var attack_timer = $fire_golem_parent/Timer
@onready var hp = $EnemyInfo/HP
@onready var status_label = $EnemyInfo/status
@onready var enemy_position = $EnemyInfo/position
@onready var fire_golem_parent = $fire_golem_parent
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var knockback_timer = $fire_golem_parent/knockbackTimer
@onready var animation_player = $fire_golem_parent/AnimatedSprite2D



func _ready():
	player = Global.player_node
	hp.max_value = max_health
	hp.value = max_health

func _physics_process(delta):
	if player.global_position.x > global_position.x:
		fire_golem_parent.scale.x = 1
	else:
		fire_golem_parent.scale.x = -1
	
	distance = global_position.distance_to(player.global_position)
	
	# Determine status based on distance to the player
	if distance > AOE_RANGE:
		status = "CHASING"
	else:
		status = "ATTACKING"
	
	var direction = -1
	if player.global_position.x > global_position.x:
		direction = 1
	
	# Handle behavior based on the status
	if status == "CHASING":
		velocity.x = direction * SPEED
		if previous_x_position == global_position.x and is_on_floor():
			velocity.y = JUMP_VELOCITY
		animation_player.play("walk")
	
	elif status == "ATTACKING" and attack_timer.time_left == 0:
		velocity.x = 0
		attack()
		attack_timer.wait_time = 3  # Cooldown time for AOE attack
		attack_timer.start()
		animation_player.play("walk")
	else:
		animation_player.play("idle")  # Play idle animation if neither chasing nor attacking
	
	# Apply gravity and adjust horizontal movement in the air
	if not is_on_floor():
		velocity.y += gravity * delta
		if direction * velocity.x < 0:
			velocity.x += direction * air_speed_increment
		else:
			if abs(velocity.x) < SPEED:
				velocity.x += direction * air_speed_increment
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	enemy_position.text = str(global_position)
	status_label.text = status
	previous_x_position = global_position.x
	move_and_slide()

func attack():
	# Instantiate the AOE attack
	var aoe_instance = AOE_PREFAB.instantiate()
	aoe_instance.global_position = global_position
	
	# Add the AOE instance to the scene
	get_tree().current_scene.add_child(aoe_instance)

	# Trigger the AOE effect (e.g., a visual and damage effect)
	if aoe_instance.has_method("start_aoe_effect"):
		aoe_instance.start_aoe_effect()

func take_knockback(projectile, knockback):
	if knockbackable:
		velocity.y = knockback.y
		if projectile.position.x > position.x:
			velocity.x = knockback.x * -1
		knockback_timer.wait_time = 0.3
		knockback_timer.start()
		knockbackable = false
		await knockback_timer.timeout
		knockbackable = true

func take_damage(damage):
	health -= damage
	hp.value = health
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position)
	
	if health <= 0:
		deathParticle()
		player.num_killed += 1
		get_node("fire_golem_parent").visible = false
		get_node("EnemyInfo").visible = false
		self.collision_layer &= ~4
		await get_tree().create_timer(0.5).timeout
		queue_free()

func deathParticle():
	get_node("deathParticle").emitting = true

func summonParticle():
	var new_hit_particles = HitParticles.instantiate()
	add_child(new_hit_particles)
	var particles = new_hit_particles.get_node("hitParticles")
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	new_hit_particles.queue_free()
