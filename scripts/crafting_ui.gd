extends Control

#Recplace with dynamic call once we store known recipes
@onready var knownRecipes = ["Saber","Pistol","RPG"]
#Reminder to self, REPLACE
@onready var choice = 0
@onready var grid_container = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_container.set_columns(4)
	_redraw()

func _on_button_left_pressed():
	choice-=1
	_update()


func _on_button_right_pressed():
	choice+=1
	_update()

func _on_button_craft_pressed():
	Global.craft(knownRecipes[choice])

func _update():
	if choice<0:
		choice = knownRecipes.size()-1
	elif choice >= knownRecipes.size():
		choice = 0
	_redraw()

func _redraw():
	var materials = MasterRecipeBook.master_recipe_book[knownRecipes[choice].to_lower()]["materials"]
	var split = materials.size()/2
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
	var craftSlot = Global.inventory_slot_scene.instantiate()
	var craftItem = MasterInventory.get_item_attributes(MasterRecipeBook.master_recipe_book[knownRecipes[choice].to_lower()]["type"],knownRecipes[choice].to_lower())
	craftSlot.flip_interactable()
	grid_container.add_child(craftSlot)
	craftSlot.set_item(craftItem)
	
	for i in split:
		var slot = Global.inventory_slot_scene.instantiate()
		var item = MasterInventory.get_item_attributes("material",materials[i].to_lower())
		slot.flip_interactable()
		grid_container.add_child(slot)
		slot.set_item(item)


