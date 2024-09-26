extends Node

var level = 1
var speed = 350.0
var fall_speed = 1500.0
var jump_velocity = -1000.0
var gravity_damping = 0.5
var air_speed_increment = 25
var max_jumps = 2
var fast_fall_modifier = 1.5
var max_flight = 2.5
var dash_delay = 3
var max_health = 999
var health = max_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_item = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
