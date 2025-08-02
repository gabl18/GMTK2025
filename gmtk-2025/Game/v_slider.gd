extends VSlider

func _ready() -> void:
	var music_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	value = db_to_linear(music_db)

	value_changed.connect(_on_music_slider_value_changed)


func _on_music_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
