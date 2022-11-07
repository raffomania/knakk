extends Control

@onready var score = $"../TopBar/Score"

## Either `null` or `Cards.Suite`
## If `null`, no suite has been chosen for this turn
var chosen_suite: Variant

func _ready():
	var _err = Events.choose_card.connect(self._choose_card)
	_err = Events.consider_action.connect(self._consider_action)
	_err = Events.cancel_consider_action.connect(self._cancel_consider_action)

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

func child_node_for_suite(suite: Cards.Suite) -> Node:
	match suite:
		Cards.Suite.Diamonds: return $Diamonds
		Cards.Suite.Spades: return $Spades
		Cards.Suite.Hearts: return $Hearts
		Cards.Suite.Clubs: return $Clubs

	return null

func _consider_action(card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.CHOOSE:
		return

	mark_playable.call(can_play(card_type))
	# First, reset all slot highlights
	for child in get_children():
		child.highlight_options([])
		# De-emphasize all areas by making them transparent
		child.modulate = Color(1, 1, 1, 0.3)

	# A suite is already chosen, highlight that suite's 
	# slots for the number of the considered card
	if chosen_suite != null:
		var node = child_node_for_suite(chosen_suite)
		node.highlight_options([card_type as Array])
		# Highlight this suite by resetting the modulate value
		node.modulate = Color.WHITE

		return
	
	# User is choosing a suite, highlight slots for all other
	# numbers in the user's hand, using the suite of the card
	# the user is considering
	var card_suite_node = child_node_for_suite(card_type[0])
	var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
		return other_card_type != card_type
	)
	card_suite_node.highlight_options(other_card_types)
	# Highlight this suite by resetting the modulate value
	card_suite_node.modulate = Color.WHITE

func _cancel_consider_action() -> void:
	if chosen_suite != null:
		child_node_for_suite(chosen_suite).highlight_options(Events.card_types_in_hand)
	else:
		reset_slot_highlights()

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
	var reward = child_node_for_suite(chosen_suite).play_card(number)

	# todo replace this with a global event, ez
	if reward is Reward.Points:
		score.add(reward.points)
	elif reward is Reward.RedrawCard:
		$"../RedrawCardArea".redraw_tokens += 1
	elif reward is Reward.PlayAgain:
		$"../PlayAgainArea".play_again_tokens += 1
		
	chosen_suite = null
	reset_slot_highlights()

func reset_slot_highlights() -> void:
	for child in get_children():
		child.highlight_options([])
		child.modulate = Color.WHITE