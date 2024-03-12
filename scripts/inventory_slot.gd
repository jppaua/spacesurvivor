extends Control

@onready var item_icon = $Slot/Item_Icon
@onready var item_quantity = $Slot/Item_Quantity

@onready var item_details = $Item_Details
@onready var item_name = $Item_Details/Item_Name
@onready var item_type = $Item_Details/Item_Type
@onready var item_effect = $Item_Details/Item_Effect

var item = null
var is_over_item = false

func _process(delta):
	if Input.is_action_just_pressed("drop_item") and is_over_item:
		if item != null:
			Global.drop_item(item)
			Global.remove_item(item["type"], item["name"])

func set_empty():
	item_icon.texture = null
	item_quantity.text = ""

func set_item(new_item):
	item = new_item
	item_icon.texture = item["texture"]
	item_quantity.text = str(item["quantity"])
	item_name.text = item["name"]
	item_type.text = item["type"]
	if item["effect"] != null:
		item_effect.text = item["effect"]
	else:
		item_effect.text = ""

func _on_slot_mouse_entered():
	if item != null:
		is_over_item = true
		item_details.visible = true
	else:
		is_over_item = false
		item_details.visible = false

func _on_slot_mouse_exited():
	is_over_item = false
	item_details.visible = false
