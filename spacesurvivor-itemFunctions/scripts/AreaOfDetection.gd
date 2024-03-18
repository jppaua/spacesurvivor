extends Node2D

class_name AreaOfDetection

@onready var area_of_detection : Area2D = $Area2D_Detection

var canInteract = false
var crystal = preload("res://scenes/prefabs/item_material.tscn")

func _on_area_2d_detection_area_entered(area):	
	if area.is_in_group("ResourceCollectionNode"):
		canInteract = true
		


func _on_area_2d_detection_area_exited(area):
	if area.is_in_group("ResourceCollectionNode"):
		canInteract = false
		

func _input(event):
	if event.is_action_pressed("interact") and canInteract == true:
		print("player e")
	



