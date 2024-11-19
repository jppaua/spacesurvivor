extends Node2D

@onready var pause_menu = $PauseMenu/Control
@onready var wave_info = $ScoreTracking/VBoxContainer/Wave
@onready var enemiesremaining = $ScoreTracking/VBoxContainer/EnemiesRemaining
var paused = false

#####-WAVE BASED SYSTEM STUFF-#######
#Handling the wave based system in the level script

#set in inspector
@export var rock_elemental_scene: PackedScene

var current_wave: int
var wave_spawn_ended: bool
var enemies: Array = [] #will store my enemies, I count them here to know when to transition

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_pause_state()
	current_wave = 0
	#Global.current_wave = current_wave
	enemies.clear() #clear the enemies before next wave
	position_to_next_wave()
	update_wave_info()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		PauseMenu()
	  # Transition to the next wave when all enemies are defeated
	#print (enemies)
	if wave_spawn_ended and enemies.size() == 0:
		print("All enemies cleared. Transitioning to next wave...")
		transition_to_next_wave()

func transition_to_next_wave():
	if wave_spawn_ended:
		wave_spawn_ended = false 
	await get_tree().create_timer(2.0).timeout
	position_to_next_wave()



func position_to_next_wave():
	if enemies.size() == 0:  # Check if there are no enemies left
		#if current_wave != 0:
			#Global.moving_to_next_wave = true
		current_wave += 1
		#Global.current_wave = current_wave
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("rockElemental", 2, 2)
		print("current wave: ", current_wave)
		update_wave_info()

func prepare_spawn(type, modifier, mob_spawns):
	var mob_amount = int(2 + (current_wave * modifier * 1.2))
	var mob_wait_time: int = 2 #2 second spawn rate
	print("mob amount: ", mob_amount)
	if mob_amount >0:
		var mob_spawn_rounds = floor(mob_amount/mob_spawns)
		wave_spawn_ended = false
		spawn_type(type, mob_spawn_rounds, mob_wait_time)

#handles the actual spawning of the enemies based on the type and number of rounds
func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "rockElemental":
		var rock_elemental_spawn1 = $Node2enemiesD/rock_elemental_spawn1
		var rock_elemental_spawn2 = $Node2enemiesD/rock_elemental_spawn2
		if mob_spawn_rounds >= 1: #set spawn positions
			for i in range(int(mob_spawn_rounds)):
				var rockElemental1 = rock_elemental_scene.instantiate()
				rockElemental1.global_position = rock_elemental_spawn1.global_position
				var rockElemental2 = rock_elemental_scene.instantiate()
				rockElemental2.global_position = rock_elemental_spawn2.global_position
				add_child(rockElemental1)
				add_child(rockElemental2)
				#connect the died signal and appends to the array (when they die, they will be removed)
				rockElemental1.connect("died", Callable(self, "_on_enemy_died"))
				rockElemental2.connect("died", Callable(self, "_on_enemy_died"))
				enemies.append(rockElemental1)
				enemies.append(rockElemental2)
				update_wave_info()
				await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_ended = true

func _on_enemy_died(enemy):
	# Remove the enemy from the enemies array
	if enemies.has(enemy):
		enemies.erase(enemy) 
		print("Enemy removed, remaining enemies:", enemies.size())
	enemy.queue_free()
	update_wave_info()

func PauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func reset_pause_state():
	paused = false  
	Engine.time_scale = 1 


func update_wave_info():
	wave_info.text = "Wave: %d" % current_wave
	enemiesremaining.text = "Enemies Remaining: %d" % enemies.size()
