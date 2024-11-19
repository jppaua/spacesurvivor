extends CharacterBody2D


const BASE_SPEED = 300.0
const SPEED_VARIATION = 200.0
const JUMP_VELOCITY = -700.0
const MIN_DISTANCE = 300
const MAX_DISTANCE = 450
var air_speed_increment = 25
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 999
var knockbackable = false
var health = max_health
var previous_x_position
var distance
var status = "CHASING"
var player
var HitParticles = preload("res://scenes/prefabs/hit_particle.tscn")
var flying_mob = true
var min_flying_height = 300  # Minimum height above the platform
var max_flying_height = 400  # Maximum height above the platform
var altitude_speed = 50
var current_speed = BASE_SPEED
var speed_change_direction = 1

@onready var attack_timer = $flying_geode_parent/Timer
@onready var hp = $EnemyInfo/HP
@onready var status_label = $EnemyInfo/status
@onready var enemy_position = $EnemyInfo/position
@onready var flying_geode_parent = $flying_geode_parent
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var knockback_timer = $flying_geode_parent/knockbackTimer
@onready var platform_raycast = $flying_geode_parent/PlatformRayCast


func _ready():
	player = Global.player_node
	hp.max_value = max_health
	hp.value = max_health

func _physics_process(delta):
	if player.global_position.x > global_position.x:
		flying_geode_parent.scale.x = 1
	else:
		flying_geode_parent.scale.x = -1
	
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
	
	if status == "CHASING" or status == "RETREATING":
		update_speed(delta)
		velocity.x = direction * current_speed

	
	if status == "RETREATING":
		velocity.x = (direction * BASE_SPEED * 0.7 * -1)
	
	if status == "ATTACKING" and attack_timer.time_left == 0:
		velocity.x = 0;
		attack()
		attack_timer.wait_time = 2
		attack_timer.start()
	
	# Calculate flying height relative to platform
	if flying_mob:
		var platform_height = get_platform_height()
		var min_target_height = platform_height - min_flying_height
		var max_target_height = platform_height - max_flying_height

		if global_position.y < max_target_height:
			velocity.y += altitude_speed * delta  # Move downwards
		elif global_position.y > min_target_height:
			velocity.y -= altitude_speed * delta  # Move upwards
		#else:
			#velocity.y = 0  # Stop vertical movement if within target height range
			
	if not is_on_floor() && !flying_mob:
		velocity.y += gravity * delta
		if direction * velocity.x < 0:
			velocity.x += direction * air_speed_increment
		else:
			if abs(velocity.x) < BASE_SPEED:
				velocity.x += direction * air_speed_increment
	#decreases speed rapidly when not holding direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
	enemy_position.text = str(global_position)
	status_label.text = status
	previous_x_position = global_position.x
	move_and_slide()
	
func update_speed(delta):
	if speed_change_direction == 1:
		current_speed += SPEED_VARIATION * delta
		if current_speed >= BASE_SPEED + SPEED_VARIATION:
			current_speed = BASE_SPEED + SPEED_VARIATION
			speed_change_direction = -1
	else:
		current_speed -= SPEED_VARIATION * delta
		if current_speed <= BASE_SPEED - SPEED_VARIATION:
			current_speed = BASE_SPEED - SPEED_VARIATION
			speed_change_direction = 1

func attack():
	var projectile = load("res://scenes/prefabs/void.tscn")
	var projectile_instance = projectile.instantiate()
	var scale = Global.player_node.get_node("PlayerParent").scale
	projectile_instance.global_position = global_position
	projectile_instance.scale = scale
	get_tree().current_scene.add_child(projectile_instance)

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

func take_damage(damage):
	health -= damage
	hp.value = health
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position)
	
	
	if health <= 0:
		deathParticle()
		player.num_killed += 1
		get_node("flying_geode_parent").visible = false
		get_node("EnemyInfo").visible = false
		self.collision_layer &= ~4
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

# Function to get platform height using RayCast2D
func get_platform_height() -> float:
	if platform_raycast.is_colliding():
		return platform_raycast.get_collision_point().y
	else:
		return 0  # Default or base height if no platform is detected











