extends Control


@export var score: Score

signal play_again

func _ready():
	# Use modulate instead of `visible` to preserve
	# the position of the `FinalScorePosition` node
	modulate = Color.TRANSPARENT
	$ScoreBox/Buttons/Score/Reward.visible = false
	$ScoreBox/Buttons/PlayAgain.pressed.connect(_on_play_again)
	$ScoreBox/Buttons/Share.pressed.connect(_on_share_result)
	Events.game_over.connect(_on_game_over)


func _on_game_over():
	var position_node = $ScoreBox/Buttons/Score/Reward
	var score_position = position_node.global_position + position_node.size / 2
	var target_size = $ScoreBox/Buttons/Score/Reward.size
	await score.animate_final_score(score_position, target_size)

	modulate = Color.WHITE


func _on_play_again():
	play_again.emit()


func _toggle_buttons_visible(should_be_visible):
	$ScoreBox/Buttons/PlayAgain.visible = should_be_visible
	$ScoreBox/Buttons/Share.visible = should_be_visible

func _on_share_result():
	_toggle_buttons_visible(false)
	# Somehow, waiting for one frame is not enough
	await get_tree().process_frame
	await get_tree().process_frame
	var image = get_viewport().get_texture().get_image()
	_toggle_buttons_visible(true)
	var timestamp = Time.get_datetime_dict_from_system()
	var userdir = OS.get_user_data_dir()
	var filename = userdir + "/screenshot_" + str(timestamp.year) + "-" + str(timestamp.month) + "-" + str(timestamp.day) + "_" + str(timestamp.hour) + "-" + str(timestamp.minute) + "-" + str(timestamp.second) + ".png"
	var result = image.save_png(filename)
	if result != OK:
		printerr("Error saving screenshot:", result)

	OS.shell_open(filename)
