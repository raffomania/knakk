class_name Score extends Control


var score: set = set_score
var reward_queue: Array[RewardMarker] = []
var reward_animation_running := false

func _ready():
	score = 0

	var _err = Events.receive_reward.connect(_on_receive_reward)


func _on_receive_reward(marker: RewardMarker):
	if not (marker.reward is Reward.Points):
		return

	reward_queue.push_back(marker)

	_process_reward_queue()


## Each obtained reward plays an animation.
## Wait for this animation to complete and then play the animation
## for any new rewards that were obtained in the meantime.
## This happens for example when both a row and a column in 
## the spades area are completed in a single move.
func _process_reward_queue():

	if reward_queue.is_empty() or reward_animation_running:
		return

	var marker = reward_queue.pop_front()

	reward_animation_running = true
	
	# Draw the RewardMarker above field and cards
	marker.z_index = 100

	var original_size = marker.size
	await marker.tween_to_large_center()
	marker.tween_to_size(original_size)
	await marker.tween_to_position(global_position)
	marker.queue_free()

	score += marker.reward.points

	reward_animation_running = false

	# Check if any markers were added in the meantime
	_process_reward_queue()


func set_score(value: int):
	score = value
	$Reward.reward = Reward.Points.new(score)


func animate_final_score(final_position: Vector2, target_size: Vector2):
	$Reward.animation_speed = 2.0

	await get_tree().create_timer(.8).timeout
	$Reward.reward = Reward.Points.new(0)
	var duration = score / 20.0
	await $Reward.tween_to_large_center()
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_score, 0, score, duration)
	await tween.finished
	await get_tree().create_timer(.3).timeout

	$Reward.tween_to_size(target_size)
	await $Reward.tween_to_position(final_position - target_size / 2)

	$Reward.animation_speed = 1.0

