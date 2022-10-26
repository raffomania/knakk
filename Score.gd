extends Label

var score: int:
	set(value):
		score = value
		text = str(score)

func _ready():
	score = 0

func add(value: int) -> void:
	score += value