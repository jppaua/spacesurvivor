extends Node

var num_players = 16
var bus = "SFX"

var music = AudioStreamPlayer.new()
var musicPos = 0
var rest = "res://audio/music/Ben Prunty - FTL - 01 Space Cruise (Title).mp3"
var battle = "res://audio/music/Ben Prunty - FTL - 01 Space Cruise (Title).mp3"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(music)
	music.bus = "Music"
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus

func changeMusic(restMusic, battleMusic):
	rest = restMusic
	battle = battleMusic
	resetMusic()

func resetMusic():
	music.stop()
	music.stream = load(rest)
	musicPos = 0
	music.play()

func isSameTrack(track, track2):
	if music.playing == true:
		if music.stream == load(track) or music.stream == load(track2):
			return true
	return false

func changeRestBattle(restBattle: bool):
	if music.get_stream() == load(battle) and restBattle == true:
		music.stop()
		music.stream = load(rest)
		music.play(musicPos)
	elif music.get_stream() == load(rest) and restBattle == false:
		music.stop()
		music.stream = load(battle)
		music.play(musicPos)

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	#Prevents a long queue of sounds that would otherwise be noticeable
	if queue.size()<10:
		queue.append(sound_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	musicPos = music.get_playback_position()
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
