extends Control

@onready var timer: Timer = $Timer
@onready var texture: AtlasTexture = $TextureRect.texture

signal finished

var frames
var current_frame

func _ready() -> void:
	frames = texture.atlas.get_size().x/texture.region.size.x-1
	current_frame = 0
	texture.region.position.x = 0

func play_anim() -> void:

	timer.start()
	
	while current_frame < frames:
		await timer.timeout
		texture.region.position.x += texture.region.size.x
		current_frame += 1
	
	finished.emit()
