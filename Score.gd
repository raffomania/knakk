extends Control


var score:
	set(value):
		score = value
		$Reward.reward = Reward.Points.new(score)


func _ready():
	score = 0
	$Reward.color = ColorPalette.PURPLE

	var _err = Events.receive_reward.connect(_receive_reward)


func _receive_reward(reward: Reward) -> void:
	if reward is Reward.Points:
		score += reward.points
