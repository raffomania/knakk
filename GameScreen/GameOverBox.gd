extends Control


@export var score: Score

signal play_again

func _ready():
	visible = false
	$Score/Reward.visible = false
	$ScoreBox/Buttons/PlayAgain.pressed.connect(_on_play_again)
	$ScoreBox/Buttons/Share.pressed.connect(_on_share_result)
	Events.game_over.connect(_on_game_over)
	if OS.get_name() == "Web":
		$ScoreBox/Buttons/Share.visible = false


func _on_game_over():
	await get_tree().create_timer(1).timeout
	var position_node = $Score/Reward
	var target_size = position_node.size
	var score_position = position_node.global_position + target_size / 2
	await score.animate_final_score(score_position, target_size)

	visible = true


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
	var userdir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var filename = userdir + "/screenshot_" + str(timestamp.year) + "-" + str(timestamp.month) + "-" + str(timestamp.day) + "_" + str(timestamp.hour) + "-" + str(timestamp.minute) + "-" + str(timestamp.second) + ".png"
	print("saving ", filename)
	var result = image.save_png(filename)
	if result != OK:
		printerr("Error saving screenshot:", result)
		return

	OS.shell_open(filename)
