extends Control

#func _ready():
	#SoundManager.continueMusic(self)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world/main_menu.tscn")
