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









