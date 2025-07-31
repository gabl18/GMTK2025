extends Control

@export var track_color_1: Color
@export var track_color_2: Color
@export var track_color_3: Color
@export var track_color_4: Color
@export var track_color_5: Color

@onready var track_1: Sprite2D = $VinylPlayer/Disc/Track1
@onready var track_2: Sprite2D = $VinylPlayer/Disc/Track2
@onready var track_3: Sprite2D = $VinylPlayer/Disc/Track3
@onready var track_4: Sprite2D = $VinylPlayer/Disc/Track4
@onready var track_5: Sprite2D = $VinylPlayer/Disc/Track5

@onready var game_controler: Node2D = $GameControler

func _ready() -> void:
	track_1.modulate = track_color_1
	track_2.modulate = track_color_2
	track_3.modulate = track_color_3
	track_4.modulate = track_color_4
	track_5.modulate = track_color_5
	
	game_controler.note_colors = [track_color_1,track_color_2,track_color_3,track_color_4,track_color_5]
