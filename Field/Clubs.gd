extends HBoxContainer

const COLOR := ColorPalette.BLUE

const SLOT_SCENE = preload("res://Slot/Slot.tscn")

## Slots in a column list, from left to right
var slots = [
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
	}, {
		reward = Reward.Points.new(28),
	},
]

@onready var suite_symbol = $SuiteSymbol

func _ready():
	spawn_slots()

## Create Slot nodes
## Slots are positioned automatically since we're extending HBoxContainer
func spawn_slots() -> void:
	for column_index in len(slots):
		var slot_spec = slots[column_index]
		var node = SLOT_SCENE.instantiate()

		# todo remove slot_size in other field scripts
		node.color = COLOR
		node.reward = slot_spec.reward

		add_child(node)
		slot_spec.node = node

		# For every slot except the last one, spawn a "<" label
		if column_index < len(slots) - 1:
			spawn_separator_label()

## A label between slots indicating that each slot has to contain a number higher than their 
## left neighbors
func spawn_separator_label() -> void:
	var label = Label.new()
	label.text = "<"
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", COLOR)
	add_child(label)

## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not find_playable_slots(number).is_empty()

func play_suite(card_node: Card) -> void:
	# Move card to position of the suite symbol
	card_node.move_to(suite_symbol.global_position + suite_symbol.size / 2)

## Mark the slot for the given number as played and
## return the reward gained by playing this card
func play_number(number: Cards.Number) -> Slot:
	var playable_slots = find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_column = playable_slots[0]
	var slot_spec = slots[slot_column]
	slot_spec.played_number = number

	# Reset highlights
	highlight_options([])

	return slot_spec.node

## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array) -> void:
	# Reset all highlights
	for slot in slots:
		slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		for slot_column in find_playable_slots(card_type[1]):
			slots[slot_column].node.is_highlighted = true

## Find column indexes for slots that can be filled using a Clubs card with the given number
func find_playable_slots(number: Cards.Number) -> Array[int]:
	for column_index in len(slots):
		var slot = slots[column_index]
		# Skip any slots that are already played
		if slot.has("played_number"):
			continue

		# The first slot can be filled with any number
		if column_index == 0:
			return [column_index]

		# For other slots, check their predecessor for a smaller number than the one the user wants to play
		var previous_slot = slots[column_index - 1]
		if (previous_slot.has("played_number")
			and previous_slot.played_number < number 
		):
			return [column_index]

	return []
