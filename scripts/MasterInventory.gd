extends Node

var master_inventory = {
	"firearm":{
		"pistol":{
			"type": "FIREARM",
			"name": "Pistol",
			"texture": preload("res://assets/weapons/pistol.png"),
			"description": "Dual Pistols fire shots",
			"is_dual_wield": true,
			"is_full_auto": true,
			"damage": 5,
			"rate_of_fire": 0.25,
			"accuracy": 1,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1
		},
		"rpg":{
			"type": "FIREARM",
			"name": "RPG",
			"texture": preload("res://assets/weapons/rpg.png"),
			"description": "Fires explosives",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 20,
			"rate_of_fire": 1,
			"accuracy": 1,
			"quantity": 1,
			"x_offset": -8,
			"y_offset": -2,
		},
		"default":{
			"type": "FIREARM",
			"name": "Default Firearm",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"description": "no TYPE FIREARM with that NAME found",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 1,
			"rate_of_fire": 1,
			"accuracy": 1,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		}
	},
	"melee":{
		"saber":{
			"type": "MELEE",
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
			"type": "MELEE",
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
			"type": "MATERIAL",
			"name": "Iron",
			"texture": preload("res://assets/resources/iron.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"charoite":{
			"type": "MATERIAL",
			"name": "Charoite",
			"texture": preload("res://assets/resources/charoite.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"crystal":{
			"type": "MATERIAL",
			"name": "Crystal",
			"texture": preload("res://assets/resources/crystal.png"),
			"description": "Crafting Material",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
		},
		"default":{
			"type": "MATERIAL",
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
			"type": "DEFAULT TYPE",
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
