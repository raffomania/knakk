extends Label

var score: int:
	set(value):
		score = value
		text = "%d Points" % score

func _ready():
	score = 0

func add(value: int) -> void:
	score += value