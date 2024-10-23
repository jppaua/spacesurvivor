extends Node

var master_recipe_book={
	"saber":{
		"type":"melee",
		"name":"Saber",
		#If this is the final recipe Smh
		"materials":["Charoite","Iron",3,1],
	},
	"pistol":{
		"type":"firearm",
		"name":"Pistol",
		#If this is the final recipe Smh
		"materials":["Charoite","Iron",2,3],
	},
	"rpg":{
		"type":"firearm",
		"name":"RPG",
		#If this is the final recipe Smh
		"materials":["Crystal","Iron",3,3],
	}
}

func verify(item):
	if master_recipe_book.has(item.to_lower()):
		return true
	return false
