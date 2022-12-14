extends Control


var score:
	set(value):
		score = value
		$Reward.reward = Reward.Points.new(score)


func _ready():
	score = 0

	var _err = Events.receive_reward.connect(_on_receive_reward)


func _on_receive_reward(marker: RewardMarker):
	if not (marker.reward is Reward.Points):
		return
	
	# Draw the RewardMarker above field and cards
	marker.z_index = 100

	await marker.tween_to_position(global_position)
	marker.queue_free()

	score += marker.reward.points

