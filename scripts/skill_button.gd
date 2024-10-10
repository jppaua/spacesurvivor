extends TextureButton
class_name SkillNode

@export var skill_name: String = ""
@export var values: Array[float] = [0.0]

@onready var panel = $Panel
@onready var line_2d = $Line2D

var level = 0
var maxed = false

func _process(delta):
	line_2d.clear_points()
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)

func _on_pressed():
	if(PlayerStats.level < 1) or maxed:
		return
	maxed = true
	PlayerStats.level -= 1
	level = min(level+1, 1)
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.7217630147934, 0.99999982118607, 0.7375340461731)
	SignalBus.skill_unlocked.emit(skill_name, values[level-1])
	PlayerStats
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level > 0:
			skill.disabled = false
