## The collection of cards that the player can choose from
extends Node2D


## When the player uses a token to play the current hand again,
## we increment this to allow them more plays before the turn is marked complete
var play_again_count := 0
## Count the cards played: once two cards are played, the turn is over
var cards_played_this_turn := 0
# todo make this const
var card_scene := preload("res://Card/Card.tscn")
## Each time a card is played, increase its z-index so it's displayed above
## all other cards lying on the table
var played_cards_z_index = 0

## The deck provides us with new cards when a card is played
# todo see if we can get rid of this reference somehow
@onready var deck := $"../Deck"


func _ready():
	redraw_hand()

	var _err = Events.take_action.connect(self._on_take_action)

	## After a turn is complete, the deck resets. When that happens, we want to draw
	## a fresh hand from the newly shuffled deck
	deck.reset_complete.connect(self.redraw_hand)


## For debugging: redraw the current hand when R is pressed
func _unhandled_input(event: InputEvent):
	if event.is_action_released("reset_hand") and OS.is_debug_build():
		redraw_hand()

		if len(deck.cards_in_deck) < 3:
			deck.reset()


## Discard the current hand and draw a new one
func redraw_hand():
	for child in get_children():
		child.queue_free()
	
	for _i in range(0,3):
		draw_card(deck.draw_card())


func node_for_card_type(card_type: Array) -> Node:
	return get_children().filter(func(child): 
		return child.card_type == card_type
	)[0]


## Draw a new card from the deck and insert it into the hand
func draw_card(card_type: Array):
	var card = card_scene.instantiate()
	card.set_card_type(card_type)
	# Display card above all played cards
	card.z_index = played_cards_z_index + 1
	add_child(card)
	position_cards()


## Look at all cards and evenly distribute their position across the
## available screen space
func position_cards():
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


func _on_take_action(_card_type: Array, action: Events.Action, card_node: Card):
	if action == Events.Action.REDRAW:
		card_node.is_played = true

		# Remove card from hand, but make sure it keeps its global position on screen
		var card_position = card_node.global_position
		remove_child(card_node)
		card_node.global_position = card_position

		# user chose to redraw, draw a new card now
		draw_card(deck.draw_card())

	if action == Events.Action.PLAY_AGAIN:
		play_again_count += 1

		card_node.is_played = true

		# Remove card from hand, but make sure it keeps its global position on screen
		var card_position = card_node.global_position
		remove_child(card_node)
		card_node.global_position = card_position

		# Duplicate other cards
		for child in get_children():
			draw_card(child.card_type)

		position_cards()

	if action == Events.Action.CHOOSE:
		cards_played_this_turn += 1

		# Remove card from hand, but make sure it keeps its global position on screen
		var card_position = card_node.global_position
		remove_child(card_node)
		card_node.global_position = card_position

		card_node.is_played = true
		card_node.z_index = played_cards_z_index
		played_cards_z_index += 1

		var slot_was_filled = cards_played_this_turn >= 2
		if slot_was_filled:
			cards_played_this_turn = 0

			if play_again_count > 0:
				play_again_count -= 1
			else:
				redraw_hand()
				Events.turn_complete.emit()
