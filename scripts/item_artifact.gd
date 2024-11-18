extends CharacterBody2D

@export var item_type = "artifact"
@export var item_name = ""
var item_texture: Texture
var item_description = ""
var item_stat = ""
var item_buff_type= ""
var item_buff = 0
var item_is_dual_wield = false
var item_quantity = 0
var item_x_offset = 0
var item_y_offset = 0
var item_x_barrel = 0
var item_y_barrel = 0
var scene_path = "res://scenes/prefabs/item_artifact.tscn"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 800.0

@onready var icon_sprite = $icon_sprite

var player_in_vaccum_range = false
var player_in_pickup_range = false

func _ready():
	set_item_data(MasterInventory.get_item_attributes(item_type.to_lower(), item_name.to_lower()))
	icon_sprite.texture = item_texture

func _physics_process(delta):
	
	if player_in_vaccum_range:
		var direction = (Global.player_node.position - global_position).normalized()
		velocity = direction * SPEED
	
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	move_and_slide()

func pickup_item():
	var item = {
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"description": item_description,
		"stat": item_stat,
		"buff_type": item_buff_type,
		"buff": item_buff,
		"is_dual_wield": item_is_dual_wield,
		"quantity": item_quantity,
		"x_offset": item_x_offset,
		"y_offset": item_y_offset,
		"x_barrel": item_x_barrel,
		"y_barrel": item_y_barrel,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()

func _on_vacuum_zone_body_entered(body):
	if body.is_in_group("Player"):
		player_in_vaccum_range = true
		#body.interact_ui.visible = true
 		
func _on_vacuum_zone_body_exited(body):
	if body.is_in_group("Player"):
		player_in_vaccum_range = false
		#body.interact_ui.visible = false

func _on_pickup_zone_body_entered(body):
	player_in_pickup_range = true
	if body.is_in_group("Player") and player_in_pickup_range:
		pickup_item()
	

func set_item_data(data):
	#print(data)
	item_type = data["type"]
	item_name = data["name"]
	item_texture = data["texture"]
	item_description = data["description"]
	item_stat = data["stat"]
	item_buff_type = data["buff_type"]
	item_buff = data["buff"]
	item_quantity = data["quantity"]
	item_x_offset = data["x_offset"]
	item_y_offset = data["y_offset"]
	if data.has("x_barrel"):
		item_x_barrel = data["x_barrel"]
	if data.has("y_barrel"):
		item_y_barrel = data["y_barrel"]
	if data.has("is_dual_wield"):
		item_is_dual_wield = data["is_dual_wield"]












