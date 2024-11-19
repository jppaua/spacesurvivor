extends Control

var menuMusic = "res://audio/music/Ben Prunty - FTL - 01 Space Cruise (Title).mp3"

func _ready():
	if !SoundManager.isSameTrack(menuMusic,menuMusic):
		SoundManager.changeMusic(menuMusic,menuMusic)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world/level_1.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world/options.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
