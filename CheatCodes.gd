extends Node

const REWARD_MARKER_SCENE = preload("res://Reward/RewardMarker.tscn")

func _unhandled_input(event):
	if not OS.is_debug_build():
		return

	if event.is_action_released("game_over"):
		Events.game_over.emit()

	if event.is_action_released("round_over"):
		Events.round_complete.emit()

	if event.is_action_released("reset_hand"):
		$'../Hand'.redraw_hand()

	if event.is_action_released("add_redraw_bonus"):
		var marker: RewardMarker = REWARD_MARKER_SCENE.instantiate()
		marker.reward = Reward.RedrawCard.new()
		add_child(marker)
		Events.receive_reward.emit(marker)

	if event.is_action_released("add_play_again_bonus"):
		var marker = REWARD_MARKER_SCENE.instantiate()
		marker.reward = Reward.PlayAgain.new()
		add_child(marker)
		Events.receive_reward.emit(marker)
