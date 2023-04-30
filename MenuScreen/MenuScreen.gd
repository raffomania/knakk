extends MarginContainer


signal continue_game
signal new_game(with_tutorial: bool)
signal settings_changed(new_settings: SettingsObject)

var settings := SettingsObject.load_from_file()


func _ready():
	$VBoxContainer/Buttons/Start.pressed.connect(_on_game_start)
	$VBoxContainer/Buttons/Tutorial.pressed.connect(_on_tutorial)
	$VBoxContainer/Buttons/Continue.pressed.connect(func(): continue_game.emit())
	$VBoxContainer/Buttons/VBoxContainer/Credits.pressed.connect(_on_credits)
	$VBoxContainer/Credits.back.connect(_on_credits_back)
	$VBoxContainer/Buttons/DarkModeToggle.toggled.connect(_on_dark_mode_toggle)

	$VBoxContainer/Buttons/Continue.visible = false

	await get_tree().process_frame

	$VBoxContainer/Buttons/DarkModeToggle.button_pressed = settings.dark_mode


## Start a new game
func _on_game_start():
	new_game.emit(false)
	# wait for camera transition to finish
	await get_tree().create_timer(2).timeout
	$VBoxContainer/Buttons/Continue.visible = true


## Start a new game in tutorial mode
func _on_tutorial():
	new_game.emit(true)
	# wait for camera transition to finish
	await get_tree().create_timer(2).timeout
	$VBoxContainer/Buttons/Continue.visible = true


## Open the credits
func _on_credits():
	$VBoxContainer/Buttons.visible = false
	$VBoxContainer/Credits.visible = true


## Close the credits
func _on_credits_back():
	$VBoxContainer/Buttons.visible = true
	$VBoxContainer/Credits.visible = false

## Open the settings
func _on_settings():
	$VBoxContainer/Buttons.visible = false
	$VBoxContainer/Settings.visible = true


## Close the settings
func _on_settings_back():
	$VBoxContainer/Buttons.visible = true
	$VBoxContainer/Settings.visible = false


func _on_dark_mode_toggle(active: bool):
	settings.dark_mode = active
	settings.save()
	settings_changed.emit(settings)
