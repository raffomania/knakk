extends Label

## An array of [suite, number] arrays
## Cards on top of the deck are at the end of the array
var cards_in_deck: Array[Array]

func _init():
	self.reset()

## Refill the deck with all possible cards and shuffle them
func reset():
	self.cards_in_deck = []
	for suite in Cards.Suite:
		for number in Cards.Number:
			self.cards_in_deck.push_back([Cards.Suite[suite], Cards.Number[number]])
	self.cards_in_deck.shuffle()

## Remove the top card from the deck and return it as a [suite, number] array
func draw_card() -> Array:
	var card = self.cards_in_deck.pop_back()
	self.update_count()
	return card

## Update the text showing how many cards are left in the deck
func update_count():
	self.text = "%d cards in deck" % len(self.cards_in_deck)
