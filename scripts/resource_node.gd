extends Node2D


@export var item_type = ""
@export var item_name = ""
@export var resource_amount = 0
@export var texture: Texture
var is_harvestable = false
@onready var sprite_2d = $Sprite2D


func _ready():
	sprite_2d.texture = texture
	sprite_2d.scale = Vector2(10,10)


func _process(_delta):
	if is_harvestable and Input.is_action_just_pressed("interact") and resource_amount > 0:
		MasterInventory.spawn_item(item_type, item_name, transform.origin)
		resource_amount -= 1
		print(resource_amount)


func _on_harvest_area_body_entered(body):
	if body.is_in_group("Player"):
		is_harvestable = true

func _on_harvest_area_body_exited(body):
	if body.is_in_group("Player"):
		is_harvestable = false
