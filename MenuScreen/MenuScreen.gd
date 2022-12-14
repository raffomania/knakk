extends MarginContainer


signal continue_game
signal new_game(with_tutorial: bool)


func _ready():
	$VBoxContainer/Buttons/Start.pressed.connect(_on_game_start)
	$VBoxContainer/Buttons/Tutorial.pressed.connect(_on_tutorial)
	$VBoxContainer/Buttons/Continue.pressed.connect(func(): continue_game.emit())
	$VBoxContainer/Buttons/Credits.pressed.connect(_on_credits)
	$VBoxContainer/Credits.back.connect(_on_credits_back)

	Events.game_over.connect(_on_game_over)

	$VBoxContainer/Buttons/Continue.visible = false


## Start a new game
func _on_game_start():
	new_game.emit(false)
	# wait for camera transition to finish
	await get_tree().create_timer(2).timeout
	$VBoxContainer/Buttons/Continue.visible = true


## Start a new game in tutorial mode
func _on_tutorial():
	new_game.emit(true)


func _on_game_over():
	$VBoxContainer/Buttons/Continue.visible = false


## Open the credits
func _on_credits():
	$VBoxContainer/Buttons.visible = false
	$VBoxContainer/Credits.visible = true


## Close the credits
func _on_credits_back():
	$VBoxContainer/Buttons.visible = true
	$VBoxContainer/Credits.visible = false
