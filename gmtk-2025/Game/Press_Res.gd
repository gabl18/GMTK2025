class_name PressRes extends Resource

@export var Presses: Array[bool]

func duplicate_deep() -> PressRes:
	var res = PressRes.new()
	res.Presses = Presses.duplicate(true)
	return res
	
