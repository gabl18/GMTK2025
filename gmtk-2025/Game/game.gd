extends Node2D

@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier

@onready var bass: AudioStreamPlayer = $Bass
@onready var melody: AudioStreamPlayer = $Melody
@onready var drum: AudioStreamPlayer = $Drum
@onready var chords: AudioStreamPlayer = $Chords

@onready var tracks = [melody, drum, chords]

@export var beat_count: int

signal _next_loop

func _ready() -> void:
	rhythm_notifier.beat.connect(_try_next_loop)
	randomize()
	while true:
		_play_random_loop()
		print(tracks.filter(func (x): return x.playing))
		await _next_loop
	
	
func _play_random_loop():
	bass.play()
	for track in tracks:
		if randi() % 2:
			track.play()

func _try_next_loop(beat:int):
	print(beat % beat_count)
	if beat % beat_count == 0:
		_next_loop.emit()
