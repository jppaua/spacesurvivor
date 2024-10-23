extends Control

@onready var num_of_points = $"NinePatchRect/Num of Points"

# Called when the node enters the scene tree for the first time.
func _ready():
	num_of_points.text = str(PlayerStats.level) + " Points"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num_of_points.text = str(PlayerStats.level) + " Points"
