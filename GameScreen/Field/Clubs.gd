extends Control


const COLOR := ColorPalette.BLUE
const SLOT_SCENE = preload("res://GameScreen/Slot/Slot.tscn")

## Slots in a column list, from left to right
var _slots = [
	{
		reward = Reward.Points.new(3),
	}, {
		reward = Reward.Points.new(6),
	}, {
		reward = Reward.RedrawCard.new()
	}, {
		reward = Reward.Points.new(10),
	}, {
		reward = Reward.PlayAgain.new()
	}, {
		reward = Reward.Points.new(15),
	}, {
		reward = Reward.Points.new(21),
	},
]

@onready var _suite_symbol = $SuiteSymbol
@onready var _slot_container: HBoxContainer = $SlotContainer


func _ready():
	_spawn_slots()


## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not _find_playable_slots(number).is_empty()


func play_suite(card_node: Card):
	# Move card to position of the suite symbol
	card_node.move_to(_suite_symbol.global_position + _suite_symbol.size / 2)


## Mark the slot for the given number as played and
## return the reward gained by playing this card
func play_number(number: Cards.Number) -> Slot:
	var playable_slots = _find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_column = playable_slots[0]
	var slot_spec = _slots[slot_column]
	slot_spec.played_number = number

	# Reset highlights
	highlight_options([])

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

		# todo remove slot_size in other field scripts
		node.color = COLOR
		node.reward = slot_spec.reward

		_slot_container.add_child(node)
		slot_spec.node = node

		# For every slot except the last one, spawn a "<" label
		if column_index < len(_slots) - 1:
			_spawn_separator_label()


## A label between slots indicating that each slot has to contain a number higher than their 
## left neighbors
func _spawn_separator_label():
	var label = Label.new()
	label.text = "<"
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", COLOR)
	label.add_theme_font_size_override("font_size", 50)
	_slot_container.add_child(label)


## Find column indexes for slots that can be filled using a Clubs card with the given number
func _find_playable_slots(number: Cards.Number) -> Array[int]:
	for column_index in len(_slots):
		var slot = _slots[column_index]
		# Skip any slots that are already played
		if slot.has("played_number"):
			continue

		# The first slot can be filled with any number
		if column_index == 0:
			return [column_index]

		# For other slots, check their predecessor for a smaller number than the one the user wants to play
		var previous_slot = _slots[column_index - 1]
		if (previous_slot.has("played_number")
			and previous_slot.played_number < number 
		):
			return [column_index]

	return []
