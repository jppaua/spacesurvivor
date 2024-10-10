extends Area2D

# The duration the AOE effect remains active
@export var duration: float = 0.5
# The damage it deals
@export var damage: int = 250

# Timer to manage the lifespan of the AOE attack
var timer = 0.0

func _ready():
	# Connect the body_entered signal to detect when the player or other enemies enter the area
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Initialize the timer to remove the AOE after its duration
	timer = duration

func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()

# Function to handle when a body enters the AOE
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player detected in AOE!")
		body.take_damage(damage)
		
# New function to start the AOE effect
func start_aoe_effect():
	if $trail2:
		$trail2.emitting = true
	# Additional logic for initializing the AOE effect can go here
