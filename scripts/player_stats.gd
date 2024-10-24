extends Node

var level = 1
var speed = 300.0
var fall_speed = 1500.0
var jump_velocity = -1000.0
var gravity_damping = 0.5
var air_speed_increment = 25
var max_jumps = 1
var fast_fall_modifier = 1.5
var max_flight = 2.0
var dash_delay = 3
var dash_speed = 800
var max_health = 100
var health = max_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_item = null
 
func _ready():
	SignalBus.skill_unlocked.connect(_on_skill_unlocked)
	SignalBus.give_exp.connect(_on_give_exp)
	
func _on_skill_unlocked(skill_name, stats):
	match skill_name:
		"speed":
			speed *= stats
			SignalBus.reread_stats.emit()
		"hover":
			max_flight *= stats
			SignalBus.reread_stats.emit()
		"dash":
			dash_speed *= stats
			SignalBus.reread_stats.emit()
		"jump":
			max_jumps += stats
			SignalBus.reread_stats.emit()

func _on_give_exp():
	level += 1
