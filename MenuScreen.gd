extends MarginContainer


signal continue_game
signal new_game(with_tutorial: bool)


func _ready():
	$Buttons/Start.pressed.connect(_on_game_start)
	$Buttons/Tutorial.pressed.connect(_on_tutorial)
	$Buttons/Continue.pressed.connect(func(): continue_game.emit())

	Events.game_over.connect(_on_game_over)

	$Buttons/Continue.visible = false


func _on_game_start():
	new_game.emit(false)
	# wait for camera transition to finish
	await get_tree().create_timer(2).timeout
	$Buttons/Continue.visible = true


func _on_tutorial():
	new_game.emit(true)


func _on_game_over():
	$Buttons/Continue.visible = false
