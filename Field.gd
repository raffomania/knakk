extends Node2D

@onready var score = $"../Score"

func _ready():
	Events.choose_card.connect(self._choose_card)

## Check if `card_type` can be chosen by the player right now.
func can_play(card_type: Array, other_cards: Array[Array]) -> bool:
	if Events.chosen_suite == null:
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
	return child_node_for_suite(Events.chosen_suite as Cards.Suite).can_play(number)

func child_node_for_suite(suite: Cards.Suite) -> Node2D:
	match suite:
		Cards.Suite.Diamonds: return $Diamonds
		_: return null

func _choose_card(card_type) -> void:
	if Events.chosen_suite == null:
		play_suite(card_type[0])
	else:	
		play_number(card_type[1])
		Events.turn_complete.emit()


func play_suite(suite) -> void:
	Events.chosen_suite = suite

func play_number(number) -> void:
	match Events.chosen_suite:
		Cards.Suite.Diamonds:
			var reward = $Diamonds.play_card(number)
			score.add(reward)
		
	Events.chosen_suite = null
