extends Label

## An array of [suite, number] arrays
## Cards on top of the deck are at the end of the array
var cards_in_deck: Array[Array]

signal reset_complete

# todo why use init here?
func _init():
	reset()
	var _err = Events.round_complete.connect(reset)


## Refill the deck with all possible cards and shuffle them
func reset():
	cards_in_deck = []
	for suite in Cards.Suite:
		for number in Cards.Number:
			cards_in_deck.push_back([Cards.Suite[suite], Cards.Number[number]])
	cards_in_deck.shuffle()
	update_count()
	reset_complete.emit()


## Remove the top card from the deck and return it as a [suite, number] array
func draw_card() -> Array:
	var card = cards_in_deck.pop_back()
	update_count()
	return card


## Update the text showing how many cards are left in the deck
func update_count():
	text = "%d cards in deck" % len(cards_in_deck)
