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
			"accuracy": 0.06,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -8,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"rpg":{
			"type": "firearm",
			"name": "RPG",
			"texture": preload("res://assets/weapons/rpg.png"),
			"projectile": "res://scenes/prefabs/grenade.tscn",
			"description": "Fires explosives",
			"is_dual_wield": false,
			"is_full_auto": true,
			"damage": 20,
			"rate_of_fire": 1.0,
			"accuracy": 0.01,
			"quantity": 1,
			"x_offset": -8,
			"y_offset": -2,
			"x_barrel": 15,
			"y_barrel": -8,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"tracking rpg":{
			"type": "firearm",
			"name": "Tracking RPG",
			"texture": preload("res://assets/weapons/trackingLauncher.png"),
			"projectile": "res://scenes/prefabs/tracking_rpg.tscn",
			"description": "Fires a tracking explosive missile",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 10,
			"rate_of_fire": 1.0,
			"accuracy": 0.00,
			"quantity": 1,
			"x_offset": 1,
			"y_offset": -2,
			"x_barrel": 15,
			"y_barrel": -8,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"orbital laser device":{
			"type": "firearm",
			"name": "Orbital Laser Device",
			"texture": preload("res://assets/weapons/orbitalLaserRadio.png"),
			"projectile": "res://scenes/prefabs/orbital_laser_raycast.tscn",
			"description": "summons a massive celestial laser",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 3.0,
			"rate_of_fire": 5.0,
			"accuracy": 0.00,
			"quantity": 1,
			"x_offset": 2,
			"y_offset": -4,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"inferno wand":{
			"type": "firearm",
			"name": "Inferno Wand",
			"texture": preload("res://assets/weapons/infernoWand.png"),
			"projectile": "res://scenes/prefabs/fireball.tscn",
			"description": "Deploy all consuming fire",
			"is_dual_wield": false,
			"is_full_auto": true,
			"damage": 1,
			"rate_of_fire": 0.05,
			"accuracy": 0.8,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -45,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"ice wand":{
			"type": "firearm",
			"name": "Ice Wand",
			"texture": preload("res://assets/weapons/iceWand.png"),
			"projectile": "res://scenes/prefabs/iceblade.tscn",
			"description": "Summons forth blades of frost",
			"is_dual_wield": false,
			"is_full_auto": true,
			"damage": 3,
			"rate_of_fire": 0.1,
			"accuracy": 0.0,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -40,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		
		"storm wand":{
			"type": "firearm",
			"name": "Storm Wand",
			"texture": preload("res://assets/weapons/stormWand.png"),
			"projectile": "res://scenes/prefabs/lightning.tscn",
			"description": "unleash damaging lightning towards enemies",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 1,
			"rate_of_fire": 0.1,
			"accuracy": 0.0,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -40,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"meteor wand":{
			"type": "firearm",
			"name": "Meteor wand",
			"texture": preload("res://assets/weapons/meteorWand.png"),
			"projectile": "res://scenes/prefabs/meteor.tscn",
			"description": "Call down meteors to crush opponents",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 20,
			"rate_of_fire": 0.1,
			"accuracy": 0.0,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -40,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		"portal wand":{
			"type": "firearm",
			"name": "Portal wand",
			"texture": preload("res://assets/weapons/portalWand.png"),
			"projectile": "res://scenes/prefabs/astral_portal.tscn",
			"description": "Bid astral comets welcome from another dimension",
			"is_dual_wield": false,
			"is_full_auto": false,
			"damage": 3,
			"rate_of_fire": 0.1,
			"accuracy": 0.0,
			"quantity": 1,
			"x_offset": 5,
			"y_offset": -1,
			"x_barrel": 25,
			"y_barrel": -40,
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		},
		
		"default":{
			"type": "firearm",
			"name": "default",
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
			"scene_path": "res://scenes/prefabs/item_gun.tscn"
		}
	},
	"artifact":{
		"defensebuff":{
			"type": "artifact",
			"name": "defensebuff",
			"texture": preload("res://assets/SSAssets/Artifacts/DefenseBuff.png"),
			"description": "reduces damage taken",
			"stat": "DEFENSE",
			"buff_type": "PERCENT",
			"buff": 0.9,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_artifact.tscn"
		},
		"featherfallingbuff":{
			"type": "artifact",
			"name": "featherfallingbuff",
			"texture": preload("res://assets/SSAssets/Artifacts/featherFalling.png"),
			"description": "reduces fall speed",
			"stat": "GRAVITY",
			"buff_type": "PERCENT",
			"buff": 0.5,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_artifact.tscn"
		},
		"healthbuff":{
			"type": "artifact",
			"name": "healthbuff",
			"texture": preload("res://assets/SSAssets/Artifacts/HealthBuff.png"),
			"description": "Increases max HP",
			"stat": "HEALTH",
			"buff_type": "FLAT",
			"buff": 100,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_artifact.tscn"
		},
		"regenbuff":{
			"type": "artifact",
			"name": "regenbuff",
			"texture": preload("res://assets/SSAssets/Artifacts/regenBuff.png"),
			"description": "HP regenerates over time",
			"stat": "REGEN",
			"buff_type": "FLAT",
			"buff": 8,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_artifact.tscn"
		},
		"default":{
			"type": "artifact",
			"name": "deault",
			"texture": preload("res://assets/SSAssets/Artifacts/featherFalling.png"),
			"description": "no TYPE ARTIFACT with that NAME found",
			"stat": "default",
			"buff_type": "FLAT",
			"buff": 0,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"x_barrel": 0,
			"y_barrel": 0,
			"scene_path": "res://scenes/prefabs/item_artifact.tscn"
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
			"scene_path": "res://scenes/prefabs/item_melee.tscn"
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
			"scene_path": "res://scenes/prefabs/item_melee.tscn"
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
			"scene_path": "res://scenes/prefabs/item_material.tscn"
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
			"scene_path": "res://scenes/prefabs/item_material.tscn"
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
			"scene_path": "res://scenes/prefabs/item_material.tscn"
		},
		"default":{
			"type": "material",
			"name": "Default",
			"texture": preload("res://assets/resources/defaultItem.png"),
			"description": "no TYPE MATERIAL with that NAME found",
			"is_dual_wield": false,
			"quantity": 1,
			"x_offset": 0,
			"y_offset": 0,
			"scene_path": "res://scenes/prefabs/item_material.tscn"
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
			"scene_path": "res://scenes/prefabs/item_material.tscn"
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


func spawn_item(item_type, item_name, position):
	var new_type = "default"
	var new_name = "default"
	if master_inventory.has(item_type):
		new_type = item_type
	if master_inventory[new_type].has(item_name):
		new_name = item_name
	var item = master_inventory[new_type][new_name]
	#print(item)
	var item_scene = load(item["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item)
	item_instance.global_position = position
	get_tree().current_scene.add_child(item_instance)
	















