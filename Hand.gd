## The collection of cards that the player can choose from

extends Node2D

## The deck provides us with new cards when a card is played
@onready var deck = $"../Deck"
@onready var field = $"../Field"

var card_scene = preload("res://Cards/Card.tscn")

func _ready():
	redraw_hand()

## Discard the current hand and draw a new one
func redraw_hand() -> void:
	for child in get_children():
		child.queue_free()

	# wait for `queue_free()` to take effect
	await get_tree().process_frame

	for _i in range(0,3):
		draw_card()

## The player has chosen this card, discard it and mark it on the field
## This function assumes that playability checks have already passed
## in _consider_card
func _choose_card(card) -> void:
	field.play_card(card.card_type)
	card.queue_free()
	# todo this is unclean
	# When the chosen suite is reset to null, we know that we 
	# can draw a new hand because the last move was a number
	if field.chosen_suite == null:
		redraw_hand()

func _consider_card(card) -> void:
	var other_cards: Array[Array] = get_children() \
		.map(func(other_card): return other_card.card_type) \
		.filter(func(card_type): return card_type != card.card_type)

	card.can_play = field.can_play(card.card_type, other_cards)

## Draw a new card from the deck and insert it into the hand
func draw_card():
	var card_type = deck.draw_card()
	var card = card_scene.instantiate()
	card.set_card_type(card_type)
	card.choose.connect(_choose_card.bind(card))
	card.consider.connect(_consider_card.bind(card))
	add_child(card)
	position_cards()

## Look at all cards and evenly distribute their position across the
## available screen space
func position_cards():
	var children = get_children()
	var total_cards = len(children)
	var card_size = Cards.textures[0][0].get_size()
	card_size.x = ProjectSettings.get_setting("display/window/size/viewport_width") / total_cards
	# Start with a negative index to center the cards' positions
	# around this node's position
	var card_index = -(total_cards-1) / 2.0

	for card in children:
		var card_position = to_global(Vector2(card_size.x * card_index, -card_size.y/2))
		card.starting_position = card_position
		card.move_to(card_position)
		card_index += 1

## For debugging: redraw the current hand when R is pressed
func _unhandled_input(event):
	if event.is_action_released("reset_hand") and OS.is_debug_build():
		await redraw_hand()

		if len(deck.cards_in_deck) < 3:
			deck.reset()