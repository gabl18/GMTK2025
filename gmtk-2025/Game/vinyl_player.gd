extends Sprite2D


@onready var disc: Sprite2D = $Disc
@onready var spinner: AnimationPlayer = $Disc/Spinner
@onready var needle: Sprite2D = $Needle

@onready var track_1: Sprite2D = $Disc/Track1
@onready var track_2: Sprite2D = $Disc/Track2
@onready var track_3: Sprite2D = $Disc/Track3
@onready var track_4: Sprite2D = $Disc/Track4
@onready var track_5: Sprite2D = $Disc/Track5
@onready var tracks = [track_5,track_4,track_3,track_2,track_1,]


var needle_off_rotation := -20.4
var needle_track_rotations := [
	-10.2,
	-7,
	-2.8,
	3,
	10.7,
]

var _active_tracks: Array
var needle_goal: int
var pre_pause_rotation: float


func change_turn_speed(rps:float):
	spinner.speed_scale = rps


func reset_needle():
	var tween = get_tree().create_tween()
	tween.tween_property(needle,"rotation_degrees",needle_off_rotation,0.5)


func change_active_tracks(active_tracks:Array):
	_active_tracks = active_tracks
	var active_track_idxs: Array

	for i in range(len(_active_tracks)):
		if _active_tracks[i]:
			tracks[i].show()
			active_track_idxs.append(i)
		else:
			tracks[i].hide()
	
	var last_needle_goal = needle_goal
	while needle_goal == last_needle_goal and not active_track_idxs.is_empty():
		needle_goal = active_track_idxs.pick_random()
		active_track_idxs.erase(needle_goal)
	
	var tween = get_tree().create_tween()
	tween.tween_property(needle,"rotation_degrees",needle_track_rotations[needle_goal],0.5)
	

func pause_game():
	$Label.show()
	$AudioVisualizer.hide()
	pre_pause_rotation = needle.rotation_degrees
	reset_needle()
	spinner.pause()
	for child in disc.get_children():
		if child is Note:
			child.pause()
	

func unpause_game():
	$Label.hide()
	$AudioVisualizer.show()
	var tween = get_tree().create_tween()
	tween.tween_property(needle,"rotation_degrees",pre_pause_rotation,0.5)
	spinner.play()
	for child in disc.get_children():
		if child is Note:
			child.unpause()
	
	
