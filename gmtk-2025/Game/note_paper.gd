extends Label

var score: int = 0:
	set(value):
		score = value
		text = "Score:\n"+str(value)
