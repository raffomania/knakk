extends MarginContainer


signal continue_game
signal new_game(with_tutorial: bool)


func _ready():
	$VBoxContainer/Buttons/Start.pressed.connect(_on_game_start)
	$VBoxContainer/Buttons/Tutorial.pressed.connect(_on_tutorial)
	$VBoxContainer/Buttons/Continue.pressed.connect(func(): continue_game.emit())

	Events.game_over.connect(_on_game_over)

	$VBoxContainer/Buttons/Continue.visible = false


func _on_game_start():
	new_game.emit(false)
	# wait for camera transition to finish
	await get_tree().create_timer(2).timeout
	$VBoxContainer/Buttons/Continue.visible = true


func _on_tutorial():
	new_game.emit(true)


func _on_game_over():
	$VBoxContainer/Buttons/Continue.visible = false
