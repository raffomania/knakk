extends CanvasLayer

const STEPS := [
	"""Welcome to knakk!

In this game, you play cards to fill slots. 
In return you get points and bonuses. 
The goal is to reach the highest possible score!""",
	"""You fill a slot by playing two cards.
The first card's [b]suit[/b] [img height=60]res://GameScreen/Suit/Clubs.png[/img] [img height=60]res://GameScreen/Suit/Diamonds.png[/img] [img height=60]res://GameScreen/Suit/Spades.png[/img] [img height=60]res://GameScreen/Suit/Hearts.png[/img] selects a suit on the board above.

You can drag a card upwards to play it. [b]Try it now![/b]
""",
"""You've selected a suit!

Next, pick a [b]number[/b] to put into that suit.
A matching slot is selected automatically.

Try picking a number now!
""",
	"""You can only play numbers that match the slot's rules:
[img height=60]res://GameScreen/Suit/Clubs.png[/img]: Filled from left to right. 
[b]Each number has to be higher than the previous one[/b].
[img height=60]res://GameScreen/Suit/Diamonds.png[/img]: Filled from the top left, following the arrows. 
Numbers need to [b]fit the range[/b] on each slot.""",
	"""[img height=60]res://GameScreen/Suit/Spades.png[/img]: Filled in any order. 
Each slot needs [b]exactly the number[/b] it shows. You get a reward for each row or column you fill.
[img height=60]res://GameScreen/Suit/Hearts.png[/img]: Filled from left to right. 
Each slot needs a number [b]higher or equal[/b] to the one it shows.""",
	"""The turn indicator boxes at the top show how many turns you've played.
After each turn, your hand is topped up to 3 cards.
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
	Events.take_action.connect(_on_action_taken)

	_label.text = STEPS[_current_step]


func _on_new_game(with_tutorial: bool):
	if not with_tutorial:
		visible = false
		return

	await get_tree().create_timer(3).timeout
	visible = true


func _on_next_button_pressed():
	_current_step += 1

	_next_button.disabled = false

	if _current_step == len(STEPS) - 1:
		_next_button.text = "Finish Tutorial"
		_exit_button.visible = false
	elif _current_step in [1, 2]:
		_next_button.disabled = true

	if _current_step < len(STEPS):
		_label.text = STEPS[_current_step]
	else:
		queue_free()


func _on_action_taken(_card_type, action, _node):
	if action == Events.Action.CHOOSE and _current_step in [1, 2]:
		_next_button.disabled = false
		_on_next_button_pressed()
