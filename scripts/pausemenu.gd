extends Control


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/world/main_menu.tscn")


func _on_quit_2_pressed():
	get_tree().quit()
