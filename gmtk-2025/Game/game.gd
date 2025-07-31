extends Node2D

const NOTE = preload("res://Game/note.tscn")

@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier
@onready var vinyl_player: Sprite2D = %VinylPlayer

@onready var base: AudioStreamPlayer = $Base

@onready var player_1: AudioStreamPlayer = $"1"
@onready var player_2: AudioStreamPlayer = $"2"
@onready var player_3: AudioStreamPlayer = $"3"
@onready var player_4: AudioStreamPlayer = $"4"
@onready var player_5: AudioStreamPlayer = $"5"
@onready var tracks = [player_1,player_2, player_3, player_4,player_5]

@onready var note_spawn_location_1: Node2D = %Note_Spawn_location_1
@onready var note_spawn_location_2: Node2D = %Note_Spawn_location_2
@onready var note_spawn_location_3: Node2D = %Note_Spawn_location_3
@onready var note_spawn_location_4: Node2D = %Note_Spawn_location_4
@onready var note_spawn_location_5: Node2D = %Note_Spawn_location_5
@onready var note_spawn_locations = [note_spawn_location_1,note_spawn_location_2,note_spawn_location_3,note_spawn_location_4,note_spawn_location_5]

@export var beat_count: int

@export var miss_time: float

var note_colors

var presses :=[
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

var active_presses = []
var next_presses = []
var active_beat = 0
var time_since_last_beat = 0
var time_till_next_beat = 0


signal _next_loop

var playing_tracks := []

func _ready() -> void:
	
	
	rhythm_notifier.beat.connect(_try_next_loop)
	rhythm_notifier.beat.connect(_spawn_next_nodes)
	rhythm_notifier.beat.connect(_update_beat_timer)
	
	vinyl_player.change_turn_speed(1/(rhythm_notifier.beat_length * beat_count))
	
	randomize()
	vinyl_player.reset_needle()
	_play_first_loop()
	_generate_random_loop()
	await _next_loop
	
	while true:
		vinyl_player.change_active_tracks(next_presses.map(func(x): return x is Array))
		_play_loop(playing_tracks)
		_generate_random_loop()
	
		print(tracks.filter(func (x): return x.playing))
		await _next_loop
	

func _process(delta: float) -> void:
	time_since_last_beat += delta
	time_till_next_beat += delta


func _input(event: InputEvent) -> void:
	if not event.is_echo():
		
		if event.is_action_pressed("1"):
			_check_press(0)
		if event.is_action_pressed("2"):
			_check_press(1)
		if event.is_action_pressed("3"):
			_check_press(2)
		if event.is_action_pressed("4"):
			_check_press(3)
		if event.is_action_pressed("5"):
			_check_press(4)


func _check_press(track:int):
	if time_since_last_beat > miss_time:
		time_till_next_beat = 0
		await rhythm_notifier.beat
		if time_till_next_beat > miss_time:
			print('missed!!!')
		else:
			if active_presses[track][active_beat % beat_count]:
				print("hit(early)",str(time_till_next_beat))
			else:
				print("missed!!")
	else:
		if active_presses[track][active_beat % beat_count]:
			print("hit(late)",str(time_since_last_beat))
		else:
			print("missed!")

func _generate_random_loop():
	playing_tracks = []
	active_presses = next_presses
	while playing_tracks.is_empty():
		print(0)
		next_presses = Array()
		playing_tracks = []
		for i in range(len(tracks)):
			if randi() % 2:
				next_presses.append(presses[i])
				playing_tracks.append(tracks[i])
			else:
				next_presses.append(false)


func _play_first_loop():
	base.play()


func _play_loop(active_tracks):
	base.play()
	for track in active_tracks:
		track.play()


func _update_beat_timer(beat:int):
	active_beat = beat
	time_since_last_beat = 0


func _spawn_next_nodes(beat:int):
	for i in range(len(next_presses)):
		if next_presses[i]:
			if next_presses[i][beat % beat_count] == 1:
				var new_tween = get_tree().create_tween()
				var new_note = NOTE.instantiate()
				
				%Disc.add_child(new_note)
				new_note.modulate = note_colors[i]
				new_note.modulate.a = 0
				new_tween.tween_property(new_note,"modulate:a",1,4).set_delay(2)
				new_note.kill_in(rhythm_notifier.beat_length*beat_count)
				new_note.global_position = note_spawn_locations[i].global_position


func _try_next_loop(beat:int):
	if beat % beat_count == 0:
		_next_loop.emit()
