extends Sprite2D

func kill_in(time:int):
	await get_tree().create_timer(time).timeout
	queue_free()
