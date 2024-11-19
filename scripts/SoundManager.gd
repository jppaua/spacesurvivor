extends Node

var num_players = 8
var bus = "master"

var music = AudioStreamPlayer2D.new()
var rest = "res://audio/music/Ben Prunty - FTL - 01 Space Cruise (Title).mp3"
var battle = "res://audio/music/Ben Prunty - FTL - 01 Space Cruise (Title).mp3"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func changeMusic(restMusic, battleMusic):
	rest = restMusic
	if battleMusic == null:
		battle = rest
	else:
		battle = battleMusic
	resetMusic()

func resetMusic():
	print("Check")
	music.stop()
	music.stream = load(rest)
	music.play()

func changeRestBattle(restBattle: bool):
	if music.get_stream() == battle and restBattle == true:
		var musicPos = music.get_playback_position()
		music.stop()
		music.stream = load(rest)
		music.play(musicPos)
	elif music.get_stream() == rest and restBattle == false:
		var musicPos = music.get_playback_position()
		music.stop()
		music.stream = load(battle)
		music.play(musicPos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
