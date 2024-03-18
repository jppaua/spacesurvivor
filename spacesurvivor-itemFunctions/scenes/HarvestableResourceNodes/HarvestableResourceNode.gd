extends Area2D

class_name HarvestableResourceNode



var canInteract = false

@export var item_type = ""
@export var item_name = ""


func collect_resource():
	pass

#The amount of resources in the node
@export var starting_resources : int = 3

var current_resources : int

func _ready():
	current_resources = starting_resources






func _on_body_entered(body):
	if body.is_in_group("Player"):
		canInteract = true
		print("Player is in resourceNode")
		


func _on_body_exited(body):
	if body.is_in_group("Player"):
		canInteract = false

func _input(event):
	if event.is_action_pressed("interact"):
		print("resource node e")
		if canInteract == true:
			MasterInventory.spawn_item(item_type,item_name,transform.origin)
			

func spawn_resource():
	#var crystal_instance = crystal.instantiate()
	#crystal_instance.global_position =$Marker2D.global_position
	#get_parent().add_child(crystal_instance)
	pass
