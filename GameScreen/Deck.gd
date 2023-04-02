extends Label


## An array of [suit, number] arrays
## Cards on top of the deck are at the end of the array
var cards_in_deck: Array[Array]


# todo why use init here?
func _init():
	reset()

	# Only show card count in debug builds
	if not OS.is_debug_build():
		visible = false


## Refill the deck with all possible cards and shuffle them
func reset():
	cards_in_deck = []
	for suit in Cards.Suit:
		for number in Cards.Number:
			cards_in_deck.push_back([Cards.Suit[suit], Cards.Number[number]])
	cards_in_deck.shuffle()
	_update_count()


## Remove the top card from the deck and return it as a [suit, number] array
func draw_card() -> Array:
	if cards_in_deck.is_empty():
		reset()

	var card = cards_in_deck.pop_back()
	_update_count()
	return card


## Update the text showing how many cards are left in the deck
func _update_count():
	text = "%d cards in deck" % len(cards_in_deck)
