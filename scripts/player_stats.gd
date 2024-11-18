extends Node

var level = 1
var base_speed = 350.0
var base_fall_speed = 1500.0
var base_jump_velocity = -1000.0
var base_gravity_damping = 0.5
var base_air_speed_increment = 25
var base_max_jumps = 1
var base_fast_fall_modifier = 1.5
var base_max_flight = 2.0
var base_dash_delay = 3
var base_dash_speed = 800
var base_max_health = 100
var base_health = base_max_health
var base_damage_reduction = 1
var base_regeneration = 0
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = base_speed
var fall_speed = base_fall_speed
var jump_velocity = base_jump_velocity
var gravity_damping = base_gravity_damping
var air_speed_increment = base_air_speed_increment
var max_jumps = base_max_jumps
var fast_fall_modifier = base_fast_fall_modifier
var max_flight = base_max_flight
var dash_delay = base_dash_delay
var dash_speed = base_dash_speed
var max_health = base_max_health
var health = base_max_health
var gravity = base_gravity
var damage_reduction = base_damage_reduction
var regeneration = base_regeneration

 
func _ready():
	#SignalBus.calc_stats.connect(_on_calc_stats)
	SignalBus.skill_unlocked.connect(_on_skill_unlocked)
	SignalBus.give_exp.connect(_on_give_exp)
	SignalBus.calc_stats.connect(_on_calc_stats)

func _on_calc_stats():
	var speed_buff = 0
	var fall_speed_buff = 0
	var jump_velocity_buff = 0
	var max_jumps_buff = 0
	var max_health_buff = 0
	var gravity_buff = 0
	var damage_reduction_buff = 0
	var regeneration_buff = 0
	
	for artifact in Global.artifacts:
		if artifact != null:
			match artifact["stat"]:
				"GRAVITY":
					gravity_buff += artifact["buff"]
				"HEALTH":
					max_health_buff += artifact["buff"]
				"DEFENSE":
					damage_reduction_buff += artifact["buff"]
				"REGEN":
					regeneration_buff += artifact["buff"]
	
	max_health = base_max_health + max_health_buff
	var apply_grav = 1 if gravity_buff == 0 else gravity_buff
	print(apply_grav)
	gravity = base_gravity * apply_grav 
	print(gravity)
	damage_reduction = base_damage_reduction - damage_reduction_buff
	regeneration = base_regeneration + regeneration_buff
	SignalBus.reread_stats.emit()

func _on_skill_unlocked(skill_name, stats):
	match skill_name:
		"speed":
			speed *= stats
		"hover":
			max_flight *= stats
		"dash":
			dash_speed *= stats
		"jump":
			max_jumps += stats
	SignalBus.reread_stats.emit()

func _on_give_exp():
	level += 1
