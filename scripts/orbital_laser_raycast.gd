extends Node2D

var damage = 0
var printed = false
@onready var ray_cast = $RayCast2D
@onready var line = $Line2D


func _ready():
	global_position = get_global_mouse_position()
	rotation_degrees = 0

func _draw():
	if ray_cast.is_colliding():
		draw_line(Vector2.ZERO, ray_cast.get_collision_point() - global_position, Color.RED, 2)
		var collision_point = ray_cast.get_collision_point()
		if !printed:
			print(collision_point)
			printed = true
	else:
		draw_line(Vector2.ZERO, ray_cast.target_position, Color.GREEN, 2)

func _process(delta):
	queue_redraw()
