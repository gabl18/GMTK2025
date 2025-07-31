extends Node2D

const NOTE = preload("res://Game/note.tscn")

@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier
@onready var disc: Sprite2D = %Disc

@onready var base: AudioStreamPlayer = $Base

@onready var bass: AudioStreamPlayer = $Bass
@onready var melody: AudioStreamPlayer = $Melody
@onready var drum: AudioStreamPlayer = $Drum
@onready var chords: AudioStreamPlayer = $Chords
@onready var tracks = [bass,melody, drum, chords]

@onready var note_spawn_location_bass: Node2D = $Note_Spawns/Note_Spawn_location_Bass
@onready var note_spawn_location_melody: Node2D = $Note_Spawns/Note_Spawn_location_Melody
@onready var note_spawn_location_drum: Node2D = $Note_Spawns/Note_Spawn_location_Drum
@onready var note_spawn_location_chords: Node2D = $Note_Spawns/Note_Spawn_location_Chords
@onready var note_spawn_locations = [note_spawn_location_bass,note_spawn_location_melody,note_spawn_location_drum,note_spawn_location_chords]

@export var beat_count: int

var presses :=[
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]

var active_presses =[]
var empty_press_list = []

signal _next_loop

var playing_tracks := []

func _ready() -> void:
	for x in range(beat_count):
		empty_press_list.append(0)
	
	
	rhythm_notifier.beat.connect(_try_next_loop)
	rhythm_notifier.beat.connect(_spawn_next_nodes)
	%Spinner.speed_scale = 1/(rhythm_notifier.beat_length * beat_count)
	randomize()
	
	_play_first_loop()
	_generate_random_loop()
	await _next_loop
	
	while true:
		_play_loop(playing_tracks)
		_generate_random_loop()
		print(tracks.filter(func (x): return x.playing))
		await _next_loop


func _generate_random_loop():

	playing_tracks = []
	while playing_tracks.is_empty():
		active_presses = Array()
		playing_tracks = []
		for i in range(len(tracks)):
			if randi() % 2:
				active_presses.append(presses[i])
				playing_tracks.append(tracks[i])
			else:
				active_presses.append(empty_press_list)


func _play_first_loop():
	base.play()


func _play_loop(active_tracks):
	base.play()
	for track in active_tracks:
		track.play()


func _spawn_next_nodes(beat:int):
	for i in range(len(active_presses)):
		if active_presses[i][beat % beat_count] == 1:
			var new_tween = get_tree().create_tween()
			var new_note = NOTE.instantiate()
			new_note.modulate.a = 0
			disc.add_child(new_note)
			new_tween.tween_property(new_note,"modulate:a",1,4).set_delay(2)
			new_note.kill_in(rhythm_notifier.beat_length*beat_count)
			new_note.global_position = note_spawn_locations[i].global_position


func _try_next_loop(beat:int):
	if beat % beat_count == 0:
		_next_loop.emit()
