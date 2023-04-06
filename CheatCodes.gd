extends Node

const REWARD_MARKER_SCENE = preload("res://Reward/RewardMarker.tscn")

func _unhandled_input(event):
	if not OS.is_debug_build():
		return

	if event.is_action_released("game_over", true):
		Events.game_over.emit()

	if event.is_action_released("round_over", true):
		Events.round_complete.emit()

	if event.is_action_released("reset_hand"):
		await $'../Hand'.clear()
		$'../Hand'.refill_hand()

	if event.is_action_released("add_redraw_bonus"):
		var marker: RewardMarker = REWARD_MARKER_SCENE.instantiate()
		marker.reward = Reward.RedrawCard.new()
		marker.color = random_reward_color()
		add_child(marker)
		Events.receive_reward.emit(marker)

	if event.is_action_released("add_play_again_bonus"):
		var marker = REWARD_MARKER_SCENE.instantiate()
		marker.reward = Reward.PlayAgain.new()
		marker.color = random_reward_color()
		add_child(marker)
		Events.receive_reward.emit(marker)

	if event.is_action_pressed("toggle_debug_view"):
		$'../Deck'.visible = not $'../Deck'.visible

	if event.is_action_pressed("screenshot"):
		var image = get_viewport().get_texture().get_image()
		var timestamp = Time.get_datetime_dict_from_system()
		var userdir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
		var filename = userdir + "/screenshot_" + str(timestamp.year) + "-" + str(timestamp.month) + "-" + str(timestamp.day) + "_" + str(timestamp.hour) + "-" + str(timestamp.minute) + "-" + str(timestamp.second) + ".png"
		print("saving ", filename)
		var result = image.save_png(filename)
		if result != OK:
			printerr("Error saving screenshot:", result)

func random_reward_color():
	var colors = [ColorPalette.RED, ColorPalette.BLUE]
	return colors[randi() % colors.size()]
