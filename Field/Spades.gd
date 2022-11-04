extends Node2D

const SLOT_SIZE := 90
var X_PADDING := 100
var Y_PADDING := 110

const COLOR := ColorPalette.BLUE

const SLOT_SCENE = preload("res://Slot/Slot.tscn")
const SPADES_TEXTURE = preload("res://Suite/Spades.png")

## Slots in a column, row format, from left to right, top to bottom
var slots = [
	[
		{
			number = Cards.Number.Ace,
		},
	], [
		{
			number = Cards.Number.Five,
		}, {
			number = Cards.Number.Two,
		},
	], [
		{
			number = Cards.Number.Eight,
		}, {
			number = Cards.Number.Six,
		}, {
			number = Cards.Number.Three,
		}
	], [
		{
			number = Cards.Number.Ten,
		}, {
			number = Cards.Number.Nine,
		}, {
			number = Cards.Number.Seven,
		}, {
			number = Cards.Number.Four,
		},
	]
]

## Rewards for each column from left to right
var column_rewards = [
	Reward.Points.new(5),
	Reward.Points.new(8),
	Reward.Points.new(13),
	Reward.Points.new(21),
]

## An array of [column, row] indexes in the slots grid that represent which 
## slots have been filled
var played_slots: Array[Vector2i] = []

func _ready():
	spawn_slots()
	spawn_reward_labels()
	spawn_spades_symbol()

## Create Slot nodes and position them
func spawn_slots() -> void:
	for column_index in len(slots):
		for row_index in len(slots[column_index]):
			var slot_spec = slots[column_index][row_index]
			var node = SLOT_SCENE.instantiate()

			node.size = Vector2.ONE * SLOT_SIZE
			node.position = get_slot_position(column_index, row_index)
			node.color = COLOR
			node.text = Cards.get_number_sigil(slot_spec.number)

			add_child(node)
			slot_spec.node = node

## Create a label showing the reward for the given column
func spawn_reward_labels():
	for column_index in len(column_rewards):
		var label = Label.new()

		var reward = column_rewards[column_index]
		if reward is Reward.Points:
			label.text = str(reward.points)
		
		# Place the label below the bottom row
		label.position = get_slot_position(column_index, column_index) + Vector2(0, SLOT_SIZE)

		# Size the label like the padding between slots and center its text
		label.size = Vector2(SLOT_SIZE, Y_PADDING)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		add_child(label)

## Display a Spades symbol to show which suite this area is for
func spawn_spades_symbol() -> void:
	var spades_symbol = TextureRect.new()
	spades_symbol.texture = SPADES_TEXTURE
	spades_symbol.position = slots[0][0].node.position - Vector2(120, 0)
	spades_symbol.ignore_texture_size = true
	spades_symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(spades_symbol)
	spades_symbol.size = Vector2.ONE * SLOT_SIZE

func _draw():
	# Draw the vertical lines between slots
	for column_index in len(slots):
		for row_index in len(slots[column_index]) - 1:
			var start_position = get_slot_position(column_index, row_index) \
				+ Vector2(SLOT_SIZE * 0.5, SLOT_SIZE)
			var stop_position = start_position + Vector2(0, Y_PADDING)
			draw_line(start_position, stop_position, COLOR, 2.0, true)

		# Draw a smaller vertical line to connect the lowest slot with the reward marker
		var start_position = get_slot_position(column_index, len(slots[column_index]) - 1) \
			+ Vector2(SLOT_SIZE * 0.5, SLOT_SIZE)
		var stop_position = start_position + Vector2(0, Y_PADDING * 0.3)
		draw_line(start_position, stop_position, COLOR, 2.0, true)

## For a given column and row index, get the position for the corresponding slot
## on the screen
func get_slot_position(column_index, row_index):
	return Vector2(
		(column_index + 1) * (SLOT_SIZE + X_PADDING),
		(row_index + 4 - column_index) * (SLOT_SIZE + Y_PADDING)
	)

## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not find_playable_slots(number).is_empty()

## Return the reward gained by playing this card
func play_card(number: Cards.Number) -> Reward:
	var playable_slots = find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_position = playable_slots[0]
	var slot_spec = slots[slot_position.x][slot_position.y]
	played_slots.append(slot_position)
	slot_spec.node.is_played = true

	# Reset highlights
	highlight_options([])

	return get_reward_for_column(slot_position.x)

func get_reward_for_column(column_index: int) -> Reward:
	# For each slot in the column, check if it has been filled
	for row_index in range(0, len(slots[column_index])):
		if Vector2i(column_index, row_index) not in played_slots:
			# This slot has not been filled, the reward for this column
			# is not yet reached
			return Reward.Nothing.new()

	# Every slot in this column has been played, the reward has been reached
	return column_rewards[column_index]

## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array) -> void:
	# Reset all highlights
	for row in slots:
		for slot in row:
			slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		for slot_position in find_playable_slots(card_type[1]):
			slots[slot_position.x][slot_position.y].node.is_highlighted = true

## Find slots that can be filled using a Spades card with the given number
func find_playable_slots(number: Cards.Number) -> Array[Vector2i]:
	var playable_slots: Array[Vector2i] = []
	for column_index in len(slots):
		for row_index in len(slots[column_index]):
			var slot = slots[column_index][row_index]
			var slot_position := Vector2i(column_index, row_index)
			# If the slots number matches and it hasn't been played yet, add it
			# to the playable slots
			if slot.number == number and not slot_position in played_slots:
				playable_slots.append(slot_position)
	
	return playable_slots
	
