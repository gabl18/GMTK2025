extends Sprite2D
class_name Note

var timer: Timer

func kill_in(time:int):
	timer = Timer.new()
	timer.start(time)
	queue_free()

func pause():
	timer.paused = true

func unpause():
	timer.paused = false
