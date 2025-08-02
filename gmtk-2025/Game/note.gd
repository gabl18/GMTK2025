extends Area2D
class_name Note

var timer: Timer

func set_track(track:int):
	$Note.frame = track
	add_to_group(str(track+1))

func kill_in(time:int):
	timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await timer.timeout
	
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	
	timer.start(time + randf_range(0,0.2))
	await timer.timeout
	
	$Note/AnimationPlayer.play("DIE#")
	
	await $Note/AnimationPlayer.animation_finished
	
	queue_free()

func pause():
	timer.paused = true

func unpause():
	timer.paused = false
