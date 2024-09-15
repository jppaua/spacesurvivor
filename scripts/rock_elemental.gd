extends CharacterBody2D

<<<<<<< HEAD
const SPEED = 0#260.0
const JUMP_VELOCITY = 0#-700.0
const MIN_DISTANCE = 300
const MAX_DISTANCE = 450
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 100
=======

const SPEED = 260.0
const JUMP_VELOCITY = -700.0
const MIN_DISTANCE = 300
const MAX_DISTANCE = 450
var air_speed_increment = 25
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 999
var knockbackable = true
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
var health = max_health
var previous_x_position
var distance
var status = "CHASING"
var player
var HitParticles = preload("res://scenes/prefabs/hit_particle.tscn")

<<<<<<< HEAD
@onready var timer = $rock_elemental_parent/Timer
=======
@onready var attack_timer = $rock_elemental_parent/Timer
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
@onready var hp = $EnemyInfo/HP
@onready var status_label = $EnemyInfo/status
@onready var enemy_position = $EnemyInfo/position
@onready var rock_elemental_parent = $rock_elemental_parent
@onready var damage_numbers_origin = $DamageNumbersOrigin
<<<<<<< HEAD
=======
@onready var knockback_timer = $rock_elemental_parent/knockbackTimer
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500


func _ready():
	player = Global.player_node
	hp.max_value = max_health
	hp.value = max_health

func _physics_process(delta):
	if player.global_position.x > global_position.x:
		rock_elemental_parent.scale.x = 1
	else:
		rock_elemental_parent.scale.x = -1
	
	distance = global_position.distance_to(player.global_position)
	if distance >= MAX_DISTANCE:
		status = "CHASING"
	elif distance < MIN_DISTANCE: 
		status = "RETREATING"
	else: 
		status = "ATTACKING"
	
	var direction = -1
	if player.global_position.x > global_position.x:
		direction = 1
	
	if status == "CHASING":
		velocity.x = direction * SPEED
		if previous_x_position == global_position.x and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	if status == "RETREATING":
		velocity.x = (direction * SPEED * 0.7 * -1)
		if previous_x_position == global_position.x and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
<<<<<<< HEAD
	if status == "ATTACKING" and timer.time_left == 0:
		velocity.x = 0;
		attack()
		timer.wait_time = 2
		timer.start()
=======
	if status == "ATTACKING" and attack_timer.time_left == 0:
		velocity.x = 0;
		attack()
		attack_timer.wait_time = 2
		attack_timer.start()
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
<<<<<<< HEAD
=======
		if direction * velocity.x < 0:
			velocity.x += direction * air_speed_increment
		else:
			if abs(velocity.x) < SPEED:
				velocity.x += direction * air_speed_increment
	#decreases speed rapidly when not holding direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
	
	enemy_position.text = str(global_position)
	status_label.text = status
	previous_x_position = global_position.x
	move_and_slide()

func attack():
	var projectile = load("res://scenes/prefabs/rock.tscn")
	var projectile_instance = projectile.instantiate()
	var scale = Global.player_node.get_node("PlayerParent").scale
	projectile_instance.global_position = global_position
	projectile_instance.scale = scale
	get_tree().current_scene.add_child(projectile_instance)

<<<<<<< HEAD
<<<<<<< HEAD
func take_damage():
	health -= 1
	hp.value = health
	DamageNumbers.display_number(1, damage_numbers_origin.global_position)
=======
=======
func take_knockback(projectile, knockback):
	if(knockbackable):
		velocity.y = knockback.y
		if projectile.position.x > position.x:
			velocity.x = knockback.x * -1
		knockback_timer.wait_time = 0.3
		knockback_timer.start()
		knockbackable = false
		await knockback_timer.timeout
		knockbackable = true

>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
func take_damage(damage):
	health -= damage
	hp.value = health
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position)
<<<<<<< HEAD
>>>>>>> f414d89a05b999c8ff6a5d7465f360ed099edb53
=======
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
	
	
	if health <= 0:
		deathParticle()
		player.num_killed += 1
		get_node("rock_elemental_parent").visible = false
		get_node("EnemyInfo").visible = false
<<<<<<< HEAD
<<<<<<< HEAD
=======
		self.collision_layer &= ~4
>>>>>>> f414d89a05b999c8ff6a5d7465f360ed099edb53
=======
		self.collision_layer &= ~4
>>>>>>> 9477db447deb1bcd48b6f4670c8468cd8c03d500
		await get_tree().create_timer(0.5).timeout
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











