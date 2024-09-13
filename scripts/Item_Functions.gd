extends Node

func primary_action(item):
	if item["type"] == "firearm":
		firearm_primary(item)
	if item["type"] == "melee":
		print("melee primary action called: " + str(item))
	if item["type"] == "material":
		print("material primary action called: " + str(item))

func firearm_primary(item):
	var deviance = deviance(item["accuracy"])
	var projectile = load(item["projectile"])
	var projectile_instance = projectile.instantiate()
	var right_barrel = Global.player_node.get_node("PlayerParent/RightArmParent/RightHandParent/RightBarrel")
	var left_barrel = Global.player_node.get_node("PlayerParent/LeftArmParent/LeftHandParent/LeftBarrel")
	var scale = Global.player_node.get_node("PlayerParent").scale
	projectile_instance.global_position = Vector2(right_barrel.global_position.x, right_barrel.global_position.y)
	projectile_instance.scale = scale
	projectile_instance.rotation = ((Global.player_node.get_node("PlayerParent/RightArmParent").rotation) * scale.x) + deviance
	projectile_instance.damage = item["damage"]
	get_tree().current_scene.add_child(projectile_instance)




func deviance(range):
	return randf_range(-range, range)
