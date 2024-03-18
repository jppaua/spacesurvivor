extends Node

var master_inventory = {
	"firearm":{
		"pistol":{
			"type": "firearm",
			"name": "Pistol",
			"texture": preload("res://assets/weapons/pistol.png"),
			"projectile": "res://scenes/prefabs/bullet.tscn",
			"description": "Dual Pistols fire shots",
			"is_dual_wield": true,
			"is_full_auto": true,
			"damage": 1,
			"rate_of_fire": 0.05,
			"accuracy": 0.07,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -8
		},
		"rpg":{
			"type": "firearm",
			"name": "RPG",
			"texture": preload("res://assets/weapons/rpg.png"),
			"projectile": "res://scenes/prefabs/grenade.tscn",
			"description": "Fires explosives",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 150,
			"rate_of_fire": 1.2,
			"accuracy": 0.02,
			"quantity": 1,
			"x_offset": -8,
			"y_offset": -2,
			"x_barrel": 15,
			"y_barrel": -8
		},
		"default":{
			"type": "firearm",
			"name": "Default Firearm",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"projectile": "res://scenes/prefabs/bullet.tscn",
			"description": "no TYPE FIREARM with that NAME found",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 1,
			"rate_of_fire": 1,
			"accuracy": 0,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
		}
	},
	"melee":{
		"saber":{
			"type": "melee",
			"name": "Saber",
			"texture": preload("res://assets/weapons/saber.png"),
			"description": "its a sword",
			"is_dual_wield": false,
			"damage": 30,
			"rate_of_fire": 0.8,
			"range": 30,
			"quantity": 1,
			"x_offset": 18,
			"y_offset": 0,
		},
		"default":{
			"type": "melee",
			"name": "Default Melee",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"description": "no TYPE MELEE with that NAME found",
			"is_dual_wield": false,
			"damage": 1,
			"rate_of_fire": 1,
			"range": 1,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		}
	},
	"material":{
		"iron":{
			"type": "material",
			"name": "Iron",
			"texture": preload("res://assets/resources/iron.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"charoite":{
			"type": "material",
			"name": "Charoite",
			"texture": preload("res://assets/resources/charoite.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"crystal":{
			"type": "material",
			"name": "Crystal",
			"texture": preload("res://assets/resources/crystal.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"default":{
			"type": "material",
			"name": "Default Material",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"description": "no TYPE MATERIAL with that NAME found",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		}
	},
	"default":{
		"default":{
			"type": "default",
			"name": "default",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"description": "no TYPE found, check for typos, or recheck MasterInventory.gd",
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		}
	}
}

func get_item_attributes(item_type, item_name):
	var new_type = "default"
	var new_name = "default"
	if master_inventory.has(item_type):
		new_type = item_type
	if master_inventory[new_type].has(item_name):
		new_name = item_name
	return master_inventory[new_type][new_name]















