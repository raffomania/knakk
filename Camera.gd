extends Camera2D


enum Screen {
	MENU,
	GAME,
	GAME_OVER
}

var current_screen := Screen.MENU

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func go_to_game_over_screen():
	assert(current_screen == Screen.GAME)
	animation_player.play("game_to_game_over")
	current_screen = Screen.GAME_OVER
	await animation_player.animation_finished


func go_to_game_screen():
	match current_screen:
		Screen.MENU:
			animation_player.play("menu_to_game")
		Screen.GAME_OVER:
			animation_player.play_backwards("game_to_game_over")

	current_screen = Screen.GAME
	await animation_player.animation_finished


func go_to_menu_screen():
	match current_screen:
		Screen.GAME:
			animation_player.play_backwards("menu_to_game")

	current_screen = Screen.MENU
	await animation_player.animation_finished
