extends Control


const GAME_SCENE = preload("res://GameScreen.tscn")


func _ready():
	var _e = Events.game_over.connect(_on_game_over)
	_e = Events.new_game.connect(_on_new_game)


func _unhandled_input(event):
	if event.is_action_released("game_over") and OS.is_debug_build():
		_on_game_over()


func _on_game_over():
	# Move to game over screen
	await $Camera.go_to_game_over_screen()

	# Remember score for later
	var score = $GameScreen/TopBar/Score.score

	# Remove the game completely and create a new one
	$GameScreen.queue_free()
	await get_tree().process_frame
	var game_node = GAME_SCENE.instantiate()
	add_child(game_node)

	# Play score animation
	await get_tree().create_timer(0.5).timeout
	$GameOverScreen.animate_score(score)


func _on_new_game(_with_tutorial: bool):
	await $Camera.go_to_game_screen()

	$GameOverScreen.reset()

