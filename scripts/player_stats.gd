extends Node

var level = 1
var speed = 350.0
var jump_velocity = -1000.0
var gravity_damping = 0.5
var air_speed_increment = 25
var max_health = 999
var health = max_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_item = null


