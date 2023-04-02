extends Control

const COLOR := ColorPalette.RED
const SLOT_SCENE = preload("res://GameScreen/Slot/Slot.tscn")
const ARROW_SCENE = preload("res://GameScreen/Field/Arrow.tscn")

## Slots in a column list, from left to right
var _slots = [
	{
		number = Cards.Number.Eight,
		reward = Reward.Points.new(2),
		is_played = false,
	}, {
		number = Cards.Number.Nine,
		reward = Reward.Points.new(3),
		is_played = false,
	}, {
		number = Cards.Number.Ten,
		reward = Reward.RedrawCard.new(),
		is_played = false,
	}, {
		number = Cards.Number.Jack,
		reward = Reward.Points.new(10),
		is_played = false,
	}, {
		number = Cards.Number.Queen,
		reward = Reward.RedrawCard.new(),
		is_played = false,
	}, {
		number = Cards.Number.King,
		reward = Reward.Points.new(15),
		is_played = false,
	}, {
		number = Cards.Number.Ace,
		reward = Reward.Points.new(21),
		is_played = false,
	},
]

## A reference to the TextureRect showing that this area belongs to the Hearts suit
@onready var _suit_symbol: TextureRect = $SuitSymbol
@onready var _slot_container: HBoxContainer = $SlotContainer


func _ready():
	_spawn_slots()


## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not _find_playable_slots(number).is_empty()


func play_suit(card_node: Card):
	# Move card to position of the suit symbol
	card_node.move_to(_suit_symbol.global_position + _suit_symbol.size / 2)


## Mark the slot for the given number as played and
## return the reward gained by playing this card
func play_number(number: Cards.Number) -> Slot:
	var playable_slots = _find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Reset highlights
	highlight_options([])

	var slot_column = playable_slots[0]
	var slot_spec = _slots[slot_column]
	slot_spec.is_played = true

	return slot_spec.node


## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array):
	# Reset all highlights
	for slot in _slots:
		slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		for slot_column in _find_playable_slots(card_type[1]):
			_slots[slot_column].node.is_highlighted = true


## Create Slot nodes
## Slots are positioned automatically since we're extending HBoxContainer
func _spawn_slots():
	for column_index in len(_slots):
		var slot_spec = _slots[column_index]
		var node = SLOT_SCENE.instantiate()

		node.color = COLOR
		node.reward = slot_spec.reward
		node.text = "≥ %s" % Cards.get_number_sigil(slot_spec.number)

		_slot_container.add_child(node)
		slot_spec.node = node

		# For every slot except the last one, spawn an arrow
		if column_index < len(_slots) - 1:
			_spawn_separator_arrow()


## An arrow between slots indicating that the slots have
## to be filled left to right
func _spawn_separator_arrow():
	var arrow = ARROW_SCENE.instantiate()
	arrow.color = COLOR
	arrow.is_vertical = false
	arrow.size_flags_horizontal = SIZE_EXPAND_FILL
	arrow.size_flags_vertical = SIZE_EXPAND_FILL

	_slot_container.add_child(arrow)


## Find column indexes for slots that can be filled using a Hearts card with the given number
func _find_playable_slots(number: Cards.Number) -> Array[int]:
	for column_index in len(_slots):
		var slot = _slots[column_index]

		# The first free slot with a matching requirement is returned
		if number >= slot.number and not slot.is_played:
			return [column_index]

		# If we find a slot that is not yet played but does not match the requirements,
		# no slots are playable at all
		if not slot.is_played:
			return []

	return []
