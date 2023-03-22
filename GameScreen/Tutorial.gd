extends CanvasLayer

const STEPS := [
	"""Welcome to knakk!
In this game, you play cards to fill slots.
Each filled slot will reward you with points or bonuses. 
The goal is to get the highest possible score!""",
	"""Each turn, you select two of your three hand cards to play.
First, you pick a [b]suite[/b] [img height=60]res://GameScreen/Suite/Clubs.png[/img] [img height=60]res://GameScreen/Suite/Diamonds.png[/img] [img height=60]res://GameScreen/Suite/Spades.png[/img] [img height=60]res://GameScreen/Suite/Hearts.png[/img] card.
Its suite determines the [b]area[/b] where you'll fill a slot.
Only the suite on the card matters - its number has no effect.""",
"""Next, you pick a [b]number[/b] card. Its number determines the slot you're going to fill.

You can drag a card upwards to pick it. [b]Try it now![/b]""",
	"""Each suite area has its own rules.
[img height=60]res://GameScreen/Suite/Clubs.png[/img]: Filled from left to right, with [b]each number higher than the previous one[/b].
[img height=60]res://GameScreen/Suite/Diamonds.png[/img]: Starting from the top left corner, numbers need to [b]fit the range[/b] on each slot.""",
	"""[img height=60]res://GameScreen/Suite/Spades.png[/img]: Filled in any order. 
Each slot needs [b]exactly the number[/b] it shows.
[img height=60]res://GameScreen/Suite/Hearts.png[/img]: Filled from left to right. 
Each slot needs a number [b]higher or equal[/b] to the one it shows.""",
	"""The turn indicator boxes at the top show how many turns you've played.
After each turn, you get a new hand with three new cards.
After five turns, the deck is refilled and shuffled.
After fifteen turns, the game is over.""",
	"""Some slots will reward you with bonuses.
[img color=#303030 height=35]res://GameScreen/Action//RedrawCard.svg[/img]: Replace a card with a new one by dragging it to the bottom left corner.
[b]++[/b]: Drag a card to the bottom right corner to sacrifice it. Your other hand cards will be duplicated.""",
	"""You're ready to play.

[b]Good luck and have fun![/b]
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
		visible = false
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
