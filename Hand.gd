## The collection of cards that the player can choose from

extends Node2D

## The deck provides us with new cards when a card is played
@onready var deck := $"../Deck"

## The field is where we place marks depending on the cards
## chosen by the player
@onready var field := $"../Field"

var card_scene := preload("res://Cards/Card.tscn")

func _ready():
	redraw_hand()

	Events.consider_card.connect(self._consider_card)

## Discard the current hand and draw a new one
func redraw_hand() -> void:
	for child in get_children():
		child.queue_free()
	
	Events.card_types_in_hand = []

	# wait for `queue_free()` to take effect
	await get_tree().process_frame

	for _i in range(0,3):
		draw_card()

## The player has chosen this card, discard it and mark it on the field
## This function assumes that playability checks have already passed
## in _consider_card
func _choose_card(card) -> void:
	field.play_card(card.card_type)
	Events.card_types_in_hand.erase(card.card_type)
	card.queue_free()
	# todo this is unclean
	# When the chosen suite is reset to null, we know that we 
	# can draw a new hand because the last move was a number
	if Events.chosen_suite == null:
		redraw_hand()

## Connected in `draw_card` when a new card is created
func _consider_card(card_type: Array) -> void:
	var node = get_children().filter(func(child): 
		return child.card_type == card_type
	)[0]

	var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
		return other_card_type != card_type
	)

	node.can_play = field.can_play(card_type, other_card_types)

## Draw a new card from the deck and insert it into the hand
func draw_card() -> void:
	var card_type = deck.draw_card()
	var card = card_scene.instantiate()
	card.set_card_type(card_type)
	card.choose.connect(_choose_card.bind(card))
	add_child(card)
	Events.card_types_in_hand.append(card_type)
	position_cards()

## Look at all cards and evenly distribute their position across the
## available screen space
func position_cards() -> void:
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
func _unhandled_input(event: InputEvent):
	if event.is_action_released("reset_hand") and OS.is_debug_build():
		await redraw_hand()

		if len(deck.cards_in_deck) < 3:
			deck.reset()
