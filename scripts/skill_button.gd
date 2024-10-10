extends TextureButton
class_name SkillNode

@onready var panel = $Panel
@onready var line_2d = $Line2D
var level = 0

func _process(delta):
	line_2d.clear_points()
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)

func _on_pressed():
	print("pressed")
	level = min(level+1, 1)
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.7217630147934, 0.99999982118607, 0.7375340461731)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level > 0:
			skill.disabled = false
