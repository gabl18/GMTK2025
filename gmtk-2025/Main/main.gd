extends Node

const GAME = preload("res://Game/game.tscn")

signal any_input

func _ready() -> void:
	
	await any_input
	var tween = get_tree().create_tween()
	tween.tween_property(%Splashscreen,"modulate:a",0,1)

	$PressAnyKeyToStart.hide()
	
	$Intro.play_anim()
	await $Intro.finished
	$Intro.queue_free()
	
	%Splashscreen.hide()
	$Center/VinylPlayer.hide()
	
	var game = GAME.instantiate()
	add_child(game)
	
	tween.kill()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		any_input.emit()
