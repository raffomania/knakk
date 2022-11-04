extends Control

var score:
	set(value):
		score = value
		$Reward.reward = Reward.Points.new(score)

func _ready():
	score = 0
	$Reward.color = ColorPalette.PURPLE

func add(value: int) -> void:
	score += value
