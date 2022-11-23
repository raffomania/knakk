extends Container

const GRID_COLUMNS := 6
const GRID_ROWS := 5
const SLOT_SIZE := 90
const COLOR := ColorPalette.BLUE

const SLOT_SCENE = preload("res://Slot/Slot.tscn")
const REWARD_MARKER_SCENE = preload("res://Reward/RewardMarker.tscn")
const SPADES_TEXTURE = preload("res://Suite/Spades.png")

## Slots in a column, row format, from left to right, top to bottom
var _slots = [
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
var _column_rewards = [
	Reward.Points.new(5),
	Reward.Points.new(8),
	Reward.Points.new(13),
	Reward.Points.new(21),
]
## An array of [column, row] indexes in the slots grid that represent which 
## slots have been filled
var _played_slots: Array[Vector2i] = []
## A reference to the TextureRect showing that this area belongs to the Spades suite
var _suite_symbol


func _ready():
	# Wait for a frame for get_size() to return the correct values
	await get_tree().process_frame
	_spawn_slots()
	_spawn_reward_labels()
	_spawn_spades_symbol()


func _draw():
	var y_padding = _get_slot_padding().y
	# Draw the vertical lines between slots
	for column_index in len(_slots):
		for row_index in len(_slots[column_index]) - 1:
			var start_position = _get_slot_position(column_index, row_index) \
				+ Vector2(SLOT_SIZE * 0.5, SLOT_SIZE)
			var stop_position = start_position + Vector2(0, y_padding)
			draw_line(start_position, stop_position, COLOR, 2.0, true)

		# Draw a smaller vertical line to connect the lowest slot with the reward marker
		# But only draw it for columns that are not filled yet
		if not (_get_reward_for_column(column_index) is Reward.Nothing):
			continue

		var start_position = _get_slot_position(column_index, len(_slots[column_index]) - 1) \
			+ Vector2(SLOT_SIZE * 0.5, SLOT_SIZE)
		var stop_position = start_position + Vector2(0, y_padding * 0.3)
		draw_line(start_position, stop_position, COLOR, 2.0, true)


## Return true if the given number can be played on a slot in this area
func can_play(number: Cards.Number) -> bool:
	return not _find_playable_slots(number).is_empty()


func play_suite(card_node: Card):
	# Move card to position of the suite symbol
	card_node.move_to(_suite_symbol.global_position + _suite_symbol.size / 2)


## Return the reward gained by playing this card
func play_number(number: Cards.Number) -> Slot:
	var playable_slots = _find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_position = playable_slots[0]
	_played_slots.append(slot_position)

	# Reset highlights
	highlight_options([])

	var column_reward = _get_reward_for_column(slot_position.x)
	if not (column_reward is Reward.Nothing):
		Events.receive_reward.emit(column_reward)
		queue_redraw()

		var marker = get_node("ColumnReward%d" % slot_position.x)
		marker.queue_free()

	var slot_spec = _slots[slot_position.x][slot_position.y]
	return slot_spec.node


## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array):
	# Reset all highlights
	for row in _slots:
		for slot in row:
			slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		for slot_position in _find_playable_slots(card_type[1]):
			_slots[slot_position.x][slot_position.y].node.is_highlighted = true


## Create Slot nodes and position them
func _spawn_slots():
	for column_index in len(_slots):
		for row_index in len(_slots[column_index]):
			var slot_spec = _slots[column_index][row_index]
			var node = SLOT_SCENE.instantiate()

			node.size = Vector2.ONE * SLOT_SIZE
			node.position = _get_slot_position(column_index, row_index)
			node.color = COLOR
			node.text = Cards.get_number_sigil(slot_spec.number)

			add_child(node)
			slot_spec.node = node


## Create a label showing the reward for the given column
func _spawn_reward_labels():
	for column_index in len(_column_rewards):
		var marker = REWARD_MARKER_SCENE.instantiate()

		var reward = _column_rewards[column_index]
		marker.reward = reward
		marker.name = "ColumnReward%d" % column_index

		add_child(marker)
		
		marker.size = Vector2.ONE * SLOT_SIZE * 0.5
		marker.color = COLOR

		# Place the marker below the bottom row and center it
		var center_offset = (Vector2.ONE * SLOT_SIZE - marker.size) * 0.5
		marker.position = _get_slot_position(column_index, column_index) \
			+ Vector2(0, SLOT_SIZE) + center_offset


## Display a Spades symbol to show which suite this area is for
func _spawn_spades_symbol():
	_suite_symbol = TextureRect.new()
	_suite_symbol.texture = SPADES_TEXTURE
	_suite_symbol.position = _slots[0][0].node.position - Vector2(120, 0)
	_suite_symbol.ignore_texture_size = true
	_suite_symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(_suite_symbol)
	_suite_symbol.size = Vector2.ONE * SLOT_SIZE


## For a given column and row index, get the position for the corresponding slot
## on the screen
func _get_slot_position(column_index, row_index):
	return Vector2(
		(column_index + 2) * (SLOT_SIZE + _get_slot_padding().x),
		(row_index + 4 - column_index) * (SLOT_SIZE + _get_slot_padding().y)
	)


func _get_slot_padding() -> Vector2:
	var x_padding = (size.x - (SLOT_SIZE * GRID_COLUMNS)) / (GRID_COLUMNS - 1)
	var y_padding = (size.y - (SLOT_SIZE * GRID_ROWS)) / (GRID_ROWS - 1)
	return Vector2(x_padding, y_padding)

func _get_reward_for_column(column_index: int) -> Reward:
	# For each slot in the column, check if it has been filled
	for row_index in range(0, len(_slots[column_index])):
		if Vector2i(column_index, row_index) not in _played_slots:
			# This slot has not been filled, the reward for this column
			# is not yet reached
			return Reward.Nothing.new()

	# Every slot in this column has been played, the reward has been reached
	return _column_rewards[column_index]


## Find slots that can be filled using a Spades card with the given number
func _find_playable_slots(number: Cards.Number) -> Array[Vector2i]:
	var playable_slots: Array[Vector2i] = []
	for column_index in len(_slots):
		for row_index in len(_slots[column_index]):
			var slot = _slots[column_index][row_index]
			var slot_position := Vector2i(column_index, row_index)
			# If the slots number matches and it hasn't been played yet, add it
			# to the playable slots
			if slot.number == number and not slot_position in _played_slots:
				playable_slots.append(slot_position)
	
	return playable_slots
	
