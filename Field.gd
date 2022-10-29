extends Node2D

@onready var score = $"../Score"

## Either `null` or `Cards.Suite`
## If `null`, no suite has been chosen for this turn
var chosen_suite: Variant

func _ready():
	Events.choose_card.connect(self._choose_card)
	Events.consider_action.connect(self._consider_action)
	Events.cancel_consider_action.connect(self._cancel_consider_action)

## Check if `card_type` can be chosen by the player right now.
func can_play(card_type: Array) -> bool:
	var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
		return other_card_type != card_type
	)
	if chosen_suite == null:
		return can_play_suite(card_type[0], other_card_types)

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

func child_node_for_suite(suite: Cards.Suite) -> Variant:
	match suite:
		Cards.Suite.Diamonds: return $Diamonds
		_: return null

func _consider_action(card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.CHOOSE:
		return

	mark_playable.call(can_play(card_type))
	# First, reset all slot highlights
	$Diamonds.highlight_options([])

	# A suite is already chosen, highlight that suite's 
	# slots for the number of the considered card
	if chosen_suite != null:
		var node = child_node_for_suite(chosen_suite)
		if node != null: 
			node.highlight_options([card_type as Array])
		return
	
	# User is choosing a suite, highlight slots for all other
	# numbers in the user's hand, using the suite of the card
	# the user is considering
	var card_suite_node = child_node_for_suite(card_type[0])
	if card_suite_node != null:
		var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
			return other_card_type != card_type
		)
		card_suite_node.highlight_options(other_card_types)
		return

func _cancel_consider_action() -> void:
	if chosen_suite != null:
		$Diamonds.highlight_options(Events.card_types_in_hand)
	else:
		$Diamonds.highlight_options([])

func _choose_card(card_type: Array, action: Events.Action) -> void:
	if action != Events.Action.CHOOSE:
		return

	if chosen_suite == null:
		play_suite(card_type[0])
	else:	
		play_number(card_type[1])

func play_suite(suite) -> void:
	chosen_suite = suite

func play_number(number) -> void:
	match chosen_suite:
		# todo replace this with a global event, ez
		Cards.Suite.Diamonds:
			var reward = $Diamonds.play_card(number)
			if reward is Reward.Points:
				score.add(reward.points)
			elif reward is Reward.RedrawCard:
				$"../RedrawCardArea".redraw_tokens += 1
			elif reward is Reward.PlayAgain:
				$"../PlayAgainArea".play_again_tokens += 1
		
	chosen_suite = null
