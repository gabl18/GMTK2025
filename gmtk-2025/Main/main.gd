extends Node

const INTRO = preload("res://Game/intro.tscn")
const GAME = preload("res://Game/game.tscn")

signal any_input

func _ready() -> void:
	
	await any_input
	var tween = get_tree().create_tween()
	tween.tween_property(%Splashscreen,"modulate:a",0,1)
	
	$PressAnyKeyToStart.hide()
	
	var intro = INTRO.instantiate()
	add_child(intro)
	await intro.finished
	intro.queue_free()
	
	%Splashscreen.hide()
	
	var game = GAME.instantiate()
	add_child(game)
	$Center/VinylPlayer.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		any_input.emit()
