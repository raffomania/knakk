extends HBoxContainer

const COLOR := ColorPalette.RED

const SLOT_SCENE = preload("res://Slot/Slot.tscn")

## Slots in a column list, from left to right
var slots = [
	{
		number = Cards.Number.Ace,
		reward = Reward.Points.new(3),
	}, {
		number = Cards.Number.Two,
		reward = Reward.Points.new(6),
	}, {
		number = Cards.Number.Three,
		reward = Reward.Points.new(10),
	}, {
		number = Cards.Number.Four,
		reward = Reward.Points.new(15),
	}, {
		number = Cards.Number.Five,
		reward = Reward.Points.new(21),
	}, {
		number = Cards.Number.Six,
		reward = Reward.Points.new(28),
	}, {
		number = Cards.Number.Seven,
		reward = Reward.Points.new(36),
	}, {
		number = Cards.Number.Eight,
		reward = Reward.Points.new(45),
	}, {
		number = Cards.Number.Nine,
		reward = Reward.Points.new(55),
	},
]

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
		node.text = "≥ %s" % Cards.get_number_sigil(slot_spec.number)

		add_child(node)
		slot_spec.node = node

## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not find_playable_slots(number).is_empty()

## Mark the slot for the given number as played and
## return the reward gained by playing this card
func play_card(number: Cards.Number) -> Reward:
	var playable_slots = find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_column = playable_slots[0]
	var slot_spec = slots[slot_column]
	slot_spec.node.is_played = true

	# Reset highlights
	highlight_options([])

	return slot_spec.reward

## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array) -> void:
	# Reset all highlights
	for slot in slots:
		slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		for slot_column in find_playable_slots(card_type[1]):
			slots[slot_column].node.is_highlighted = true

## Find column indexes for slots that can be filled using a Hearts card with the given number
func find_playable_slots(number: Cards.Number) -> Array[int]:
	for column_index in len(slots):
		var slot = slots[column_index]

		# The first free slot with a matching requirement is returned
		if number >= slot.number and not slot.node.is_played:
			return [column_index]

		# If we find a slot that is not yet played but does not match the requirements,
		# no slots are playable at all
		if not slot.node.is_played:
			return []

	return []
