extends Node2D

@onready var _1: Sprite2D = $"1"
@onready var _2: Sprite2D = $"2"
@onready var _3: Sprite2D = $"3"
@onready var _4: Sprite2D = $"4"
@onready var buttons = [_1,_2,_3,_4]

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var audio_stream_player_3: AudioStreamPlayer = $AudioStreamPlayer3
@onready var audio_stream_player_4: AudioStreamPlayer = $AudioStreamPlayer4
@onready var player = [audio_stream_player_2,audio_stream_player,audio_stream_player_3,audio_stream_player_4]

@export var streams: Array[AudioStream]


func _input(event: InputEvent) -> void:
	if not event.is_echo():
		
		if event.is_action_pressed("1"):
			$AudioStreamPlayer.play()
			_1.frame = 1
			$"1/D".position.y += 4
			play_sfx()
			await get_tree().create_timer(0.1).timeout
			_1.frame = 0
			$"1/D".position.y -= 4
		if event.is_action_pressed("2"):
			_2.frame = 1
			$"2/F".position.y += 4
			play_sfx()
			await get_tree().create_timer(0.1).timeout
			_2.frame = 0
			$"2/F".position.y -= 4
			play_sfx()
		if event.is_action_pressed("3"):
			_3.frame = 1
			play_sfx()
			$"3/J".position.y += 4
			await get_tree().create_timer(0.1).timeout
			_3.frame = 0
			$"3/J".position.y -= 4
		if event.is_action_pressed("4"):
			_4.frame = 1
			$"4/K".position.y += 4
			play_sfx()
			await get_tree().create_timer(0.1).timeout
			_4.frame = 0
			$"4/K".position.y -= 4

func play_sfx():
	for x in player:
		if not x.playing:
			x.stream = streams[randi_range(0,streams.size()-1)]
			x.play()
			return
	audio_stream_player.stream = streams[randi_range(0,streams.size()-1)]
	audio_stream_player.play()
