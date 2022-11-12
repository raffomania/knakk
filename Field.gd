extends Control


## Either `null` or `Cards.Suite`
## If `null`, no suite has been chosen for this turn
var chosen_suite: Variant


func _ready():
	var _err = Events.take_action.connect(self._on_take_action)
	_err = Events.consider_action.connect(self._on_consider_action)
	_err = Events.cancel_consider_action.connect(self._on_cancel_consider_action)


## Check if `card_type` can be chosen by the player right now.
func can_play(card_type: Array) -> bool:
	var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
		return other_card_type != card_type
	)
	if chosen_suite == null:
		return can_play_suite(card_type[0], other_card_types)

	return can_play_number(card_type[1])


func can_play_suite(suite: Cards.Suite, other_cards: Array[Array]) -> bool:
	var suite_node = _child_node_for_suite(suite)
	if suite_node == null: return false

	for other_card in other_cards:
		if suite_node.can_play(other_card[1]):
			return true

	return false


func can_play_number(number: Cards.Number) -> bool:
	return _child_node_for_suite(chosen_suite as Cards.Suite).can_play(number)


func reset_slot_highlights():
	for child in get_children():
		child.highlight_options([])
		child.modulate = Color.WHITE


func _child_node_for_suite(suite: Cards.Suite) -> Node:
	match suite:
		Cards.Suite.Diamonds: return $Diamonds
		Cards.Suite.Spades: return $Spades
		Cards.Suite.Hearts: return $Hearts
		Cards.Suite.Clubs: return $Clubs

	return null


func _on_consider_action(card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.CHOOSE:
		return

	var can_play_card = can_play(card_type)
	mark_playable.call(can_play_card)

	# First, reset all slot highlights
	for child in get_children():
		child.highlight_options([])
		# De-emphasize all areas by making them transparent
		child.modulate = Color(1, 1, 1, 0.3)

	if chosen_suite == null:
		_consider_suite(card_type, can_play_card)
	else:
		_consider_number(card_type, can_play_card)
	

# User is considering playing the suite on the given card
func _consider_suite(card_type: Array, can_play_card: bool):
	if can_play_card:
		# highlight slots for all other numbers in the user's hand, 
		# using the suite of the card the user is considering
		var card_suite_node = _child_node_for_suite(card_type[0])
		var other_card_types = Events.card_types_in_hand.filter(func(other_card_type): 
			return other_card_type != card_type
		)
		card_suite_node.highlight_options(other_card_types)

		# Highlight this suite by resetting the modulate value
		card_suite_node.modulate = Color.WHITE

		Events.show_help.emit("Choose %s area" % Cards.get_suite_label(card_type[0]))
	else:
		Events.show_help.emit("Can't choose %s with your current hand" % Cards.get_suite_label(card_type[0]))


## A suite is already chosen and user is considering playing the given card's number
func _consider_number(card_type: Array, can_play_card: bool):
	if can_play_card:
		# highlight the suite's slots for the number of the considered card
		var suite_node = _child_node_for_suite(chosen_suite)
		suite_node.highlight_options([card_type as Array])

		# Highlight this suite by resetting the modulate value
		suite_node.modulate = Color.WHITE
		Events.show_help.emit("Put %s in %s area" % [Cards.get_number_label(card_type[1]), Cards.get_suite_label(card_type[0])])

		return
	else:
		Events.show_help.emit("Can't put %s in %s area" % [Cards.get_number_label(card_type[1]), Cards.get_suite_label(card_type[0])])
		return


func _on_cancel_consider_action():
	if chosen_suite != null:
		var suite_node = _child_node_for_suite(chosen_suite)
		suite_node.highlight_options(Events.card_types_in_hand)
		suite_node.modulate = Color.WHITE
	else:
		reset_slot_highlights()


func _on_take_action(card_type: Array, action: Events.Action, card_node: Node):
	if action != Events.Action.CHOOSE:
		return

	if chosen_suite == null:
		_play_suite(card_type[0], card_node)
	else:	
		_play_number(card_type[1], card_node)


func _play_suite(suite: Cards.Suite, card_node: Card):
	chosen_suite = suite

	# Add card as child of the given suite while making sure it keeps its global position on screen
	var suite_node = _child_node_for_suite(suite)
	var card_position = card_node.global_position
	suite_node.add_child(card_node)
	card_node.global_position = card_position
	# Display card behind the suite symbol
	card_node.z_index = -1 

	suite_node.play_suite(card_node)
	card_node.shrink_to_played_size()


func _play_number(number: Cards.Number, card_node: Card):
	var slot = _child_node_for_suite(chosen_suite).play_number(number)

	Events.receive_reward.emit(slot.reward)
	slot.fill_with_card(card_node)
	slot.reward = Reward.Nothing.new()

	chosen_suite = null
	reset_slot_highlights()

