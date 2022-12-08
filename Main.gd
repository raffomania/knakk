extends Control


const GAME_SCENE = preload("res://GameScreen.tscn")

@onready var camera: Camera2D = $Camera


func _ready():
	Events.game_over.connect(_on_game_over)
	$MenuScreen.continue_game.connect(_on_continue_game)
	$MenuScreen.new_game.connect(_on_new_game)
	$GameOverScreen.new_game.connect(func(): _on_new_game(false))


func _unhandled_input(event):
	if event.is_action_released("game_over") and OS.is_debug_build():
		_on_game_over()


func _on_game_over():
	# Move to game over screen
	await camera.go_to_game_over_screen()

	# Remember score for later
	var score = $GameScreen/TopBar/Score.score

	_reset_game()

	# Play score animation
	await get_tree().create_timer(0.5).timeout
	$GameOverScreen.animate_score(score)


func _on_new_game(with_tutorial: bool):
	await _reset_game()

	Events.new_game.emit(with_tutorial)

	await camera.go_to_game_screen()

	$GameOverScreen.reset()


func _on_menu_button_pressed():
	camera.go_to_menu_screen()


func _on_continue_game():
	camera.go_to_game_screen()


## Remove the game scene completely and create a new one
func _reset_game():
	$GameScreen.queue_free()
	await get_tree().process_frame
	var game_node = GAME_SCENE.instantiate()
	add_child(game_node)
	$GameScreen/TopBar/MenuButton.pressed.connect(_on_menu_button_pressed)
