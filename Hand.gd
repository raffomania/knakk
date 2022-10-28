## The collection of cards that the player can choose from

extends Node2D

## The deck provides us with new cards when a card is played
@onready var deck := $"../Deck"

var card_scene := preload("res://Cards/Card.tscn")

func _ready():
	redraw_hand()

	Events.turn_complete.connect(self._turn_complete)
	Events.choose_card.connect(self._choose_card)

## Discard the current hand and draw a new one
func redraw_hand() -> void:
	for child in get_children():
		child.queue_free()
	
	for _i in range(0,3):
		draw_card()

func _choose_card(_card_type: Array, action: Events.Action) -> void:
	if action != Events.Action.REDRAW:
		return

	# user chose to redraw, draw a new card now
	draw_card()

func _turn_complete() -> void:
	redraw_hand()

func node_for_card_type(card_type: Array) -> Node:
	return get_children().filter(func(child): 
		return child.card_type == card_type
	)[0]

## Draw a new card from the deck and insert it into the hand
func draw_card() -> void:
	var card_type = deck.draw_card()
	var card = card_scene.instantiate()
	card.set_card_type(card_type)
	add_child(card)
	position_cards()

## Look at all cards and evenly distribute their position across the
## available screen space
func position_cards() -> void:
	# In case any cards were deleted during this frame,
	# wait for `queue_free()` calls to take effect by waiting for the next frame
	await get_tree().process_frame

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
		redraw_hand()

		if len(deck.cards_in_deck) < 3:
			deck.reset()
