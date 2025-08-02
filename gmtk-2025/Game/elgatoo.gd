extends Node2D

@onready var _1: Sprite2D = $"1"
@onready var _2: Sprite2D = $"2"
@onready var _3: Sprite2D = $"3"
@onready var _4: Sprite2D = $"4"

@onready var buttons = [_1,_2,_3,_4]

func _input(event: InputEvent) -> void:
	if not event.is_echo():
		
		if event.is_action_pressed("1"):
			_1.frame = 1
			$"1/D".position.y += 4
			await get_tree().create_timer(0.1).timeout
			_1.frame = 0
			$"1/D".position.y -= 4
		if event.is_action_pressed("2"):
			_2.frame = 1
			$"2/F".position.y += 4
			await get_tree().create_timer(0.1).timeout
			_2.frame = 0
			$"2/F".position.y -= 4
		if event.is_action_pressed("3"):
			_3.frame = 1
			$"3/J".position.y += 4
			await get_tree().create_timer(0.1).timeout
			_3.frame = 0
			$"3/J".position.y -= 4
		if event.is_action_pressed("4"):
			_4.frame = 1
			$"4/K".position.y += 4
			await get_tree().create_timer(0.1).timeout
			_4.frame = 0
			$"4/K".position.y -= 4
		
