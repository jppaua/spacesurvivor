extends Node

var hotbar = []
var inventory = []
var player_node: Node = null


signal inventory_updated

@onready var inventory_slot_scene = preload("res://scenes/prefabs/inventory_slot.tscn")

func _ready():
	inventory.resize(45)
	hotbar.resize(9)

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] += item["quantity"]
			set_hotbar()
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			set_hotbar()
			inventory_updated.emit()
			return true
	return false

func remove_item(item_name):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= 1 
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			set_hotbar()
			inventory_updated.emit()
			return true
	return false

func set_hotbar():
	for i in range(hotbar.size()):
		hotbar[i] = inventory[i]

func increase_inventory_size():
	inventory_updated.emit()

#Hooks up player to this inventory
func set_player_reference(player):
	player_node = player

func drop_item(item_data):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	item_instance.global_position = Vector2(player_node.global_position.x + (118 * player_node.get_node("PlayerParent").scale.x),player_node.global_position.y - 30)
	item_instance.velocity = Vector2(200 * player_node.get_node("PlayerParent").scale.x, -400)
	get_tree().current_scene.add_child(item_instance)
	item_instance.player_in_vaccum_range = false
	item_instance.player_in_pickup_range = false

func craft(item):
	#It works, I hate it I am going to learn enough Godot to rip it a new one and make it better
	
	#verify if the item exists in the recipe book
	if MasterRecipeBook.verify(item)==false:
		return false
	
	#Copys data from MasterRecipeBook.GD
	var materials = MasterRecipeBook.master_recipe_book[item.to_lower()]["materials"]
	var split = materials.size()/2
	
	#Runs For loop to see if the player has the materials
	for i in range(split):
		if tally(materials[i])<materials[i+split]:
			return false
	#Uses remove_item and a For loop to remove items, one at a time
	for i in range(split):
		for x in range(materials[i+split]):
			remove_item(materials[i])
	
	#Adds item to the player inventory
	add_item(MasterInventory.get_item_attributes(MasterRecipeBook.master_recipe_book[item.to_lower()]["type"],item.to_lower()))
	return true

func tally(item_name):
	var count = 0
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			count += inventory[i]["quantity"]
	if(count>0):
		print("Count is ",count)
		return count
	print("Count is 0")
	return 0
