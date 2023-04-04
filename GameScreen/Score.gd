class_name Score extends Control


var score: set = set_score

func _ready():
	score = 0

	var _err = Events.receive_reward.connect(_on_receive_reward)


func _on_receive_reward(marker: RewardMarker):
	if not (marker.reward is Reward.Points):
		return
	
	# Draw the RewardMarker above field and cards
	marker.z_index = 100

	var original_size = marker.size
	await marker.tween_to_large_center()
	marker.tween_to_size(original_size)
	await marker.tween_to_position(global_position)
	marker.queue_free()

	score += marker.reward.points


func set_score(value: int):
	score = value
	$Reward.reward = Reward.Points.new(score)


func animate_final_score(final_position: Vector2, target_size: Vector2):
	$Reward.animation_speed = 2.0

	$Reward.reward = Reward.Points.new(0)
	await get_tree().create_timer(.8).timeout
	var duration = score / 20.0
	await $Reward.tween_to_large_center()
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_score, 0, score, duration)
	await tween.finished
	await get_tree().create_timer(.3).timeout

	$Reward.tween_to_size(target_size)
	await $Reward.tween_to_position(final_position - target_size / 2)

	$Reward.animation_speed = 1.0

