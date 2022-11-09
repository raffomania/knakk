extends Camera2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func go_to_game_over_screen():
	animation_player.play("go_to_game_over_screen")
	await animation_player.animation_finished


func go_to_game_screen():
	animation_player.play_backwards("go_to_game_over_screen")
	await animation_player.animation_finished
