extends Node2D

var damage = 0
var knockback = Vector2(300, -200)
var killed = false
var projectile = preload("res://scenes/prefabs/comet.tscn")

@onready var summon_timer = $SummonTimer
@onready var kill_timer = $killTimer
@onready var ring_1 = $Ring1
@onready var ring_2 = $Ring2
@onready var ring_3 = $Ring3
@onready var ring_4 = $Ring4
@onready var ring_5 = $Ring5
@onready var ring_6 = $Ring6

func _ready():
	self.global_position = get_global_mouse_position()

func _process(_delta):
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !killed:
		ring_1.radial_accel_max = -500
		ring_2.radial_accel_max = -500
		ring_3.radial_accel_max = -500
		ring_4.radial_accel_max = -500
		ring_5.radial_accel_max = -500
		ring_6.radial_accel_max = -500
		ring_1.emitting = false
		ring_2.emitting = false
		ring_3.emitting = false
		ring_4.emitting = false
		ring_5.emitting = false
		ring_6.emitting = false
		kill_timer.start(3)
		print(kill_timer.time_left)
		killed = true


func _on_kill_timer_timeout():
	queue_free()


func _on_summon_timer_timeout():
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = self.global_position
	projectile_instance.damage = damage
	get_tree().current_scene.add_child(projectile_instance)
