extends Control


## Either `null` or `Cards.Suit`
## If `null`, no suit has been chosen for this turn
var _chosen_suit: Variant


func _ready():
	var _err = Events.query_playable.connect(self._on_query_playable)
	_err = Events.consider_action.connect(self._on_consider_action)
	_err = Events.cancel_consider_action.connect(self._on_cancel_consider_action)
	_err = Events.take_action.connect(self._on_take_action)


func _on_query_playable(card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.CHOOSE:
		return

	mark_playable.call(_can_play(card_type))

func _on_consider_action(card_type: Array, action: Events.Action):
	if action != Events.Action.CHOOSE:
		return

	# First, reset all slot highlights
	for child in get_children():
		child.highlight_options([])
		# De-emphasize all areas by making them transparent
		child.modulate = Color(1, 1, 1, 0.3)

	if _chosen_suit == null:
		_consider_suit(card_type, _can_play(card_type))
	else:
		_consider_number(card_type, _can_play(card_type))
	

# User is considering playing the suit on the given card
func _consider_suit(card_type: Array, can_play_card: bool):
	var other_card_types = Events.card_types_in_hand.duplicate()
	other_card_types.erase(card_type)
	if can_play_card:
		# highlight slots for all other numbers in the user's hand, 
		# using the suit of the card the user is considering
		var card_suit_node = _child_node_for_suit(card_type[0])
		card_suit_node.highlight_options(other_card_types)

		# Highlight this suit by resetting the modulate value
		card_suit_node.modulate = Color.WHITE

		Events.show_help.emit("Choose %s" % Cards.get_suit_label(card_type[0]))
	else:
		var other_card_labels = other_card_types.map(func(card_type):
			return Cards.get_number_label(card_type[1])
		)
		Events.show_help.emit("Can't put %s in %s" % [
				" or ".join(other_card_labels),
				Cards.get_suit_label(card_type[0]),
		])


## A suit is already chosen and user is considering playing the given card's number
func _consider_number(card_type: Array, can_play_card: bool):
	if can_play_card:
		# highlight the suit's slots for the number of the considered card
		var suit_node = _child_node_for_suit(_chosen_suit)
		suit_node.highlight_options([card_type as Array])

		# Highlight this suit by resetting the modulate value
		suit_node.modulate = Color.WHITE
		Events.show_help.emit("Put %s in %s" % [Cards.get_number_label(card_type[1]), Cards.get_suit_label(_chosen_suit)])

		return
	else:
		Events.show_help.emit("Can't put %s in %s" % [Cards.get_number_label(card_type[1]), Cards.get_suit_label(_chosen_suit)])
		return


func _on_cancel_consider_action(_action: Events.Action):
	if _chosen_suit != null:
		var suit_node = _child_node_for_suit(_chosen_suit)
		suit_node.highlight_options(Events.card_types_in_hand)
		suit_node.modulate = Color.WHITE
	else:
		_reset_slot_highlights()


func _on_take_action(card_type: Array, action: Events.Action, card_node: Node):
	if action != Events.Action.CHOOSE:
		return

	if _chosen_suit == null:
		_play_suit(card_type[0], card_node)
	else:	
		_play_number(card_type[1], card_node)


func _play_suit(suit: Cards.Suit, card_node: Card):
	_chosen_suit = suit

	# Add card as child of the given suit while making sure it keeps its global position on screen
	var suit_node = _child_node_for_suit(suit)
	var card_position = card_node.global_position
	suit_node.add_child(card_node)
	card_node.global_position = card_position
	# Display card behind the suit symbol
	card_node.z_index = -1 

	suit_node.play_suit(card_node)
	card_node.shrink_to_played_size()


func _play_number(number: Cards.Number, card_node: Card):
	var slot = _child_node_for_suit(_chosen_suit).play_number(number)

	var reward_node = slot.get_reward_node()
	Events.receive_reward.emit(reward_node)
	slot.fill_with_card(card_node)

	_chosen_suit = null
	_reset_slot_highlights()


## Check if `card_type` can be chosen by the player right now.
func _can_play(card_type: Array) -> bool:
	var other_card_types = Events.card_types_in_hand.duplicate()
	other_card_types.erase(card_type)
	if _chosen_suit == null:
		return _can_play_suit(card_type[0], other_card_types)

	return _can_play_number(card_type[1])


func _can_play_suit(suit: Cards.Suit, other_cards: Array[Array]) -> bool:
	var suit_node = _child_node_for_suit(suit)
	if suit_node == null: return false

	for other_card in other_cards:
		if suit_node.can_play(other_card[1]):
			return true

	return false


func _can_play_number(number: Cards.Number) -> bool:
	return _child_node_for_suit(_chosen_suit as Cards.Suit).can_play(number)


func _reset_slot_highlights():
	for child in get_children():
		child.highlight_options([])
		child.modulate = Color.WHITE


func _child_node_for_suit(suit: Cards.Suit) -> Node:
	match suit:
		Cards.Suit.Diamonds: return $Diamonds
		Cards.Suit.Spades: return $Spades
		Cards.Suit.Hearts: return $Hearts
		Cards.Suit.Clubs: return $Clubs

	return null
