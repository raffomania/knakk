extends Control


const GAME_SCENE = preload("res://GameScreen/GameScreen.tscn")

@onready var camera: Camera2D = $Camera


func _ready():
	$MenuScreen.continue_game.connect(_on_continue_game)
	$MenuScreen.new_game.connect(_on_new_game)


func _on_new_game(with_tutorial: bool):
	await _reset_game()

	Events.new_game.emit(with_tutorial)

	await camera.go_to_game_screen()


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
	$GameScreen/GameOverBox.play_again.connect(func(): _on_new_game(false))
