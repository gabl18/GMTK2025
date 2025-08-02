extends Sprite2D


var pause := false
var credits := false


func _input(event: InputEvent) -> void:
	if not event.is_echo():
		if event.is_action_pressed("pause"):

			if pause:
				if credits:
					credits = false
					pause = true
					$AnimationPlayer.play("back_credits")
				else:
					pause = false
					$AnimationPlayer.play("slide_out")
			else:
				pause = true
				credits = false
				await get_tree().create_timer(1).timeout
				$AnimationPlayer.play("slide_in")
				await $AnimationPlayer.animation_finished
				$AnimationPlayer.play("Credits")


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if pause:
			if not credits:
				credits = true
				pause = true
				%Camera2D.make_current()
				$AnimationPlayer.play("to_credits")


func _on_control_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if pause:
			if credits:
				credits = false
				pause = true
				$AnimationPlayer.play("back_credits")
