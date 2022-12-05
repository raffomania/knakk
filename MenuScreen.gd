extends MarginContainer


func _ready():
	$Buttons/Start.pressed.connect(_on_game_start)
	$Buttons/Tutorial.pressed.connect(_on_tutorial)


func _on_game_start():
	Events.new_game.emit(false)


func _on_tutorial():
	Events.new_game.emit(true)
