extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -700.0
const MIN_DISTANCE = 300
const MAX_DISTANCE = 450
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 999
var health = max_health
var previous_x_position
var distance
var status = "CHASING"
var player
var HitParticles = preload("res://scenes/prefabs/hit_particle.tscn")

@onready var timer = $rock_elemental_parent/Timer
@onready var hp = $EnemyInfo/HP
@onready var status_label = $EnemyInfo/status
@onready var enemy_position = $EnemyInfo/position
@onready var rock_elemental_parent = $rock_elemental_parent
@onready var damage_numbers_origin = $DamageNumbersOrigin


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
	
	if status == "ATTACKING" and timer.time_left == 0:
		velocity.x = 0;
		attack()
		timer.wait_time = 2
		timer.start()
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
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

func take_damage():
	health -= 1
	hp.value = health
	DamageNumbers.display_number(1, damage_numbers_origin.global_position)
	print(position)
	summonParticle()
	
	if health <= 0:
		player.num_killed += 1
		queue_free()

func summonParticle():
	var new_hit_particles = HitParticles.instantiate()
	add_child(new_hit_particles)
	var particles = new_hit_particles.get_node("hitParticles")
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	new_hit_particles.queue_free()











