extends Control

const STEPS := [
	"""
Welcome to Clever Solitaire!
In this game, you play cards to fill slots.
Each filled slot will reward you with points or bonuses. 
The goal is to get the highest score you can!
	""",
	"""
Each turn, you pick two cards: First, a [b]suite[/b] card. 
Its suite determines the area where you'll play the second card: 
The [b]number[/b] card.  Its number determines the slot you're going to fill.
Try playing a turn now!
	""",
	"""
The turn indicator boxes at the top show how many turns you've played.
After each turn, you get a new hand with three new cards.
After five turns, the deck is refilled and shuffled.
After fifteen turns, the game is over.
	""",
	"""
Each suite has its own rules:
[b]Clubs[/b]: Filled from left to right. Each slot needs a number higher than the previous one.
[b]Diamonds[/b]: Filled from the top left corner. Each number has to fit the range indicated on the slot.
	""",
	"""
[b]Spades[/b]: Filled in [b]any[/b] order. 
Each slot needs exactly the number it shows.
[b]Hearts[/b]: Filled from left to right. 
Each slot needs a number higher or equal to the one it shows.
	""",
	"""
There are two bonuses:
[img color=#303030 height=35]res://Action//RedrawCard.svg[/img]: Replace a card with a new one by dragging it to the bottom left corner.
[b]++[/b]: Duplicate hand cards by dragging a card to the bottom right corner.
	""",
	"""
	You're ready to play.
	Good luck and have fun!
	""",
]

var _current_step := 0


@onready var _container = $BGPanel/VBoxContainer
@onready var _exit_button = _container.get_node("Buttons/ExitButton")
@onready var _next_button = _container.get_node("Buttons/NextButton")
@onready var _label: RichTextLabel = _container.get_node("TextContainer/RichTextLabel")


func _ready():
	_next_button.pressed.connect(_on_next_button_pressed)
	_exit_button.pressed.connect(queue_free)

	_label.text = STEPS[_current_step]


func _on_next_button_pressed():
	_current_step += 1

	if _current_step == len(STEPS) - 1:
		_next_button.text = "Finish Tutorial"

	if _current_step < len(STEPS):
		_label.text = STEPS[_current_step]
	else:
		queue_free()