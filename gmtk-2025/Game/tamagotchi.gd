extends Label

var loops: int = 0:
	set(value):
		loops = value
		text = "Loops:\n"+str(value)

func _ready() -> void:
	loops = 0
