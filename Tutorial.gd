extends Control

const STEPS := [
	"""
	Welcome to Clever Solitaire!
	In this game, you play cards to fill slots.
	Each filled slot will reward you with points or bonuses. 
	The goal is to get the highest score you can!
	""",
]

var _current_step := 0


func _ready():
	$Panel/BaseButton.pressed.connect(_on_next_button_pressed)

	$Panel/MarginContainer/RichTextLabel.text = STEPS[_current_step]


func _on_next_button_pressed():
	_current_step += 1
	if _current_step < len(STEPS):
		$Panel/MarginContainer/RichTextLabel.text = [_current_step]
	else:
		queue_free()
