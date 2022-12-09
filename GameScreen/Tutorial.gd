extends CanvasLayer

const STEPS := [
	"""Welcome to Clever Solitaire!
In this game, you play cards to fill slots.
Each filled slot will reward you with points or bonuses. 
The goal is to get the highest possible score!""",
	"""Each turn, you pick two cards: First, a [b]suite[/b] card. 
Its suite determines the area where you'll play the second card: 
The [b]number[/b] card.  Its number determines the slot you're going to fill.
You can drag cards upwards to play them. Try it now!""",
	"""The turn indicator boxes at the top show how many turns you've played.
After each turn, you get a new hand with three new cards.
After five turns, the deck is refilled and shuffled.
After fifteen turns, the game is over.""",
	"""Each suite has its own rules:
[b]Clubs[/b]: Filled from left to right, with each number higher than the previous one.
[b]Diamonds[/b]: Starting from the top left corner, numbers need to fit the range on each slot.""",
	"""[b]Spades[/b]: Filled in [b]any[/b] order. 
Each slot needs exactly the number it shows.
[b]Hearts[/b]: Filled from left to right. 
Each slot needs a number higher or equal to the one it shows.""",
	"""There are two bonuses:
[img color=#303030 height=35]res://GameScreen/Action//RedrawCard.svg[/img]: Replace a card with a new one by dragging it to the bottom left corner.
[b]++[/b]: Play the same hand twice by dragging a card to the bottom right corner.""",
	"""You're ready to play.
Good luck and have fun!
""",
]

var _current_step := 0


@onready var _container = $BGPanel/VBoxContainer
@onready var _exit_button = _container.get_node("Buttons/ExitButton")
@onready var _next_button = _container.get_node("Buttons/NextButton")
@onready var _label: RichTextLabel = _container.get_node("TextContainer/RichTextLabel")


func _ready():
	Events.new_game.connect(_on_new_game)

	_next_button.pressed.connect(_on_next_button_pressed)
	_exit_button.pressed.connect(queue_free)

	_label.text = STEPS[_current_step]


func _on_new_game(with_tutorial: bool):
	if not with_tutorial:
		return

	await get_tree().create_timer(3).timeout
	visible = true


func _on_next_button_pressed():
	_current_step += 1

	if _current_step == len(STEPS) - 1:
		_next_button.text = "Finish Tutorial"

	if _current_step < len(STEPS):
		_label.text = STEPS[_current_step]
	else:
		queue_free()
