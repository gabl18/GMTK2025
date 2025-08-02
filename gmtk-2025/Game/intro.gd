extends Control

@onready var timer: Timer = $Timer
@onready var texture: AtlasTexture = $TextureRect.texture

signal finished

func _ready() -> void:
	var frames = texture.atlas.get_size().x/texture.region.size.x-1
	print(frames)
	var current_frame = 0
	texture.region.position.x = 0
	timer.start()
	
	while current_frame < frames:
		await timer.timeout
		texture.region.position.x += texture.region.size.x
		current_frame += 1
	
	finished.emit()
