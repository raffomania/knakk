extends Node2D

@onready var score = $"../Score"

# todo move this to Hand.gd?
var chosen_suite: Variant = null

## Check if `card_type` can be chosen by the player right now.
func can_play(card_type: Array, other_cards: Array[Array]) -> bool:
	if chosen_suite == null:
		return can_play_suite(card_type[0], other_cards)

	return can_play_number(card_type[1])

func can_play_suite(suite: Cards.Suite, other_cards: Array[Array]) -> bool:
		var suite_node = child_node_for_suite(suite)
		if suite_node == null: return false

		for other_card in other_cards:
			if suite_node.can_play(other_card[1]):
				return true

		return false

func can_play_number(number: Cards.Number) -> bool:
	return child_node_for_suite(chosen_suite as Cards.Suite).can_play(number)

func child_node_for_suite(suite: Cards.Suite) -> Node2D:
	match suite:
		Cards.Suite.Diamonds: return $Diamonds
		_: return null

func play_card(card_type) -> void:
	if chosen_suite == null:
		play_suite(card_type[0])
		return
		
	play_number(card_type[1])

func play_suite(suite) -> void:
	chosen_suite = suite

func play_number(number) -> void:
	match chosen_suite:
		Cards.Suite.Diamonds:
			var reward = $Diamonds.play_card(number)
			score.add(reward)
		
	chosen_suite = null
