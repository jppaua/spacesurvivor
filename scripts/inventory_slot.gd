extends Control

@onready var item_icon = $Slot/Item_Icon
@onready var item_quantity = $Slot/Item_Quantity

@onready var item_details = $Item_Details
@onready var item_name = $Item_Details/Item_Name
@onready var item_type = $Item_Details/Item_Type
@onready var item_effect = $Item_Details/Item_Effect

@onready var usage_panel = $Usage_Panel

var item = null

func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible
		item_details.visible = false

func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		item_details.visible = true

func _on_item_button_mouse_exited():
		if item != null:
			item_details.visible = false

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
