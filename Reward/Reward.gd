class_name Reward

class Points extends Reward:
	var points: int


	func _init(points_value):
		points = points_value

class RedrawCard extends Reward:
	pass

class PlayAgain extends Reward:
	pass

class Nothing extends Reward:
	pass