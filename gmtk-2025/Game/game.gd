extends Node2D

const NOTE = preload("res://Game/note.tscn")

@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier
@onready var vinyl_player: Sprite2D = %VinylPlayer
@onready var red_line: Sprite2D = %RedLine

@onready var base: AudioStreamPlayer = $Base

@onready var player_1: AudioStreamPlayer = $"1"
@onready var player_2: AudioStreamPlayer = $"2"
@onready var player_3: AudioStreamPlayer = $"3"
@onready var player_4: AudioStreamPlayer = $"4"
@onready var player_5: AudioStreamPlayer = $"5"
@onready var tracks = [player_1,player_2, player_3, player_4]#player_5

@onready var note_spawn_location_1: Node2D = %Note_Spawn_location_1
@onready var note_spawn_location_2: Node2D = %Note_Spawn_location_2
@onready var note_spawn_location_3: Node2D = %Note_Spawn_location_3
@onready var note_spawn_location_4: Node2D = %Note_Spawn_location_4
@onready var note_spawn_location_5: Node2D = %Note_Spawn_location_5
@onready var note_spawn_locations = [note_spawn_location_5,note_spawn_location_4,note_spawn_location_3,note_spawn_location_2,note_spawn_location_1]


@onready var area_2d: Area2D = $Area2d

@onready var line_start_point: Vector2 = $Line2D.points[0]
@onready var line_end_point: Vector2 = $Line2D.points[1]


@export var beat_count: int
@export var song_beat_count: int

@export var perfect_distance: float
@export var nice_distance: float

@export var Stream_1: Array[AudioStream]
@export var Presses_1: Array[PressRes]
@export var Stream_2: Array[AudioStream]
@export var Presses_2: Array[PressRes]
@export var Stream_3: Array[AudioStream]
@export var Presses_3: Array[PressRes]
@export var Stream_4: Array[AudioStream]
@export var Presses_4: Array[PressRes]
@export var Stream_5: Array[AudioStream]
@export var Presses_5: Array[PressRes]
@onready var Streams = [Stream_1,Stream_2,Stream_3,Stream_4,Stream_5]
@onready var Pressess = [Presses_1,Presses_2,Presses_3,Presses_4,Presses_5]

var difficulty = 1

var score: int = 0:
	set(value):
		score = value
		%NotePaper.score = value

var note_colors


var active_presses = []
var next_presses = []
var active_beat = 0
var time_since_last_beat = 0
var time_till_next_beat = 0

var paused := false


signal _next_loop

var playing_tracks := []

func _ready() -> void:
	
	difficulty = 1
	rhythm_notifier.beat.connect(_try_next_loop)
	rhythm_notifier.beat.connect(_spawn_next_nodes)
	rhythm_notifier.beat.connect(_update_beat_timer)
	
	vinyl_player.change_turn_speed(1/(rhythm_notifier.beat_length*2 * song_beat_count))
	
	seed(int(get_global_mouse_position().x*get_global_mouse_position().y+Time.get_unix_time_from_system()))
	vinyl_player.reset_needle()
	_play_first_loop()
	_generate_random_loop()
	await _next_loop
	
	while true:
		%Tamagotchi.loops += 1
		difficulty += randf_range(0.1,0.2)
		vinyl_player.change_active_tracks(next_presses.map(func(x): return x is not bool))
		_play_loop(playing_tracks)
		_generate_random_loop()
	
		await _next_loop


func _process(delta: float) -> void:
	time_since_last_beat += delta
	time_till_next_beat += delta


func _input(event: InputEvent) -> void:
	if not event.is_echo():
		
		if event.is_action_pressed("1"):
			_check_press(1)
		if event.is_action_pressed("2"):
			_check_press(2)
		if event.is_action_pressed("3"):
			_check_press(3)
		if event.is_action_pressed("4"):
			_check_press(4)
	
		if event.is_action_pressed('pause'):
			if paused:
				vinyl_player.unpause_game()
				base.stream_paused = false
				for track in tracks:
					track.stream_paused = false
			else:
				vinyl_player.pause_game()
				base.stream_paused = true
				for track in tracks:
					track.stream_paused = true
			paused = not paused


func _check_press(track:int):
	
	var colliding_notes = area_2d.get_overlapping_areas()
	
	if not colliding_notes.is_empty():
		var colliding_notes_with_right_track = colliding_notes.filter(func(x): return x.is_in_group(str(track)))
		
		var multiplier = [12.9,15.3,16.6,18.9][track-1]
		
		if not colliding_notes_with_right_track.is_empty():
			var notes_distances = colliding_notes_with_right_track.map(func(x): return distance_point_to_line(x.global_position,to_global(line_start_point),to_global(line_end_point)))
			var closest_note = null
			var closest_distance = INF
			for i in range(len(colliding_notes_with_right_track)):
				if notes_distances[i] < closest_distance:
					closest_distance = notes_distances[i]
					closest_note = colliding_notes_with_right_track[i]

			if closest_note:
				score += int((300-(closest_distance*multiplier))/10)
				
				closest_note.queue_free()
				red_line.spawn_particle(track,[perfect_distance,nice_distance].map(func(x): return closest_distance > x).count(true))




		
	#var prev_score = score
	#if not active_presses.is_empty():
		#if time_since_last_beat > miss_time:
			#time_till_next_beat = 0
			#await rhythm_notifier.beat
			#if time_till_next_beat > miss_time:
				#pass
			#else:
				#if active_presses[track]:
					#if active_presses[track].Presses[active_beat % beat_count]:
						#active_presses[track][active_beat % beat_count] = false
						#score += (miss_time - time_till_next_beat)*100
						#red_line.spawn_particle(track,[perfect_time,nice_time].map(func(x): return time_till_next_beat > x).count(true))
#
		#else:
			#if active_presses[track]:
				#if active_presses[track].Presses[active_beat % beat_count]:
					#print(-time_since_last_beat)
					#active_presses[track].Presses[active_beat % beat_count] = false
					#score +=( miss_time - time_since_last_beat)*100
					#red_line.spawn_particle(track,[perfect_time,nice_time].map(func(x): return time_since_last_beat > x).count(true))
				#else:
					#if 0 <= ((active_beat % beat_count)-1):
						#if active_presses[track].Presses[(active_beat % beat_count)-1]:
							#print(-time_since_last_beat + rhythm_notifier.beat_length)
							#active_presses[track].Presses[(active_beat % beat_count)-1] = false
							#score += (miss_time-(time_since_last_beat + rhythm_notifier.beat_length))*100
							#red_line.spawn_particle(track,[perfect_time,nice_time].map(func(x): return time_since_last_beat + rhythm_notifier.beat_length > x).count(true))
	#if prev_score == score: score -= 30


func _generate_random_loop():
	var prev_tracks = playing_tracks.duplicate(true).map(func(x): return x.to_string())

	prev_tracks.sort()
	playing_tracks = []
	active_presses = []
	for x in next_presses:
		active_presses.append(x.duplicate_deep())
	#while playing_tracks.size() > floori(difficulty) or playing_tracks.is_empty() or prev_tracks == playing_tracks.map(func(x): return x.to_string()):
	while playing_tracks.is_empty():
		next_presses = Array()
		playing_tracks = []
		for i in range(len(tracks)):
			if randi() % 2 or true:
				var track_idx = randi_range(0,Streams[i].size()-1)
				next_presses.append(Pressess[i][track_idx])
				playing_tracks.append(tracks[i])
				tracks[i].set_meta("next",Streams[i][track_idx])
				
			else:
				next_presses.append(false)
		playing_tracks.sort()


func _play_first_loop():
	base.play()


func _play_loop(active_tracks):
	base.play()
	for track in active_tracks:
		
		track.stream = track.get_meta("next")
		track.play()


func _update_beat_timer(beat:int):
	active_beat = beat
	time_since_last_beat = 0


func _spawn_next_nodes(beat:int):
	for i in range(len(next_presses)):
		if next_presses[i]:
			if next_presses[i].Presses[beat % beat_count] == true:
				var new_tween = get_tree().create_tween()
				var new_note = NOTE.instantiate()
				
				%Disc.add_child(new_note)
				new_note.modulate = note_colors[i]
				new_note.modulate.a = 0
				new_tween.tween_property(new_note,"modulate:a",1,4).set_delay(2)
				new_note.kill_in(rhythm_notifier.beat_length*2 *song_beat_count)
				new_note.set_track(i)
				new_note.global_rotation = 0
				new_note.global_position = note_spawn_locations[i].global_position


func _try_next_loop(beat:int):
	if beat % beat_count == 0:
		_next_loop.emit()


func distance_point_to_line(point: Vector2, line_start: Vector2, line_end: Vector2) -> float:
	# 1. Get the direction vector of the line.
	var line_direction = (line_end - line_start).normalized()

	# 2. Get the normal vector of the line.
	# We rotate the direction vector by 90 degrees (or PI/2 radians).
	var normal_vector = line_direction.rotated(PI / 2.0)

	# 3. Get the vector from a point on the line (line_start) to our point.
	var point_to_line_start = point - line_start

	# 4. Project the point_to_line_start vector onto the normal vector.
	# The magnitude of this projection is the distance.
	# The 'dot' product gives us the length of the projection.
	var distance = abs(point_to_line_start.dot(normal_vector))

	return distance
