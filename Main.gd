extends Control

func _ready():
	var _e = Events.game_over.connect(_game_over)

func _game_over() -> void:
	await $Camera.go_to_game_over_screen()
	await get_tree().create_timer(0.5).timeout
	var score = $GameScreen/TopBar/Score.score
	$GameOverScreen.animate_score(score)

func _unhandled_input(event):
	if event.is_action_released("game_over") and OS.is_debug_build():
		_game_over()