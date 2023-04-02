extends Container

const GRID_COLUMNS := 6
const GRID_ROWS := 5
const COLOR := ColorPalette.RED

const SLOT_SCENE = preload("res://GameScreen/Slot/Slot.tscn")
const ARROW_SCENE = preload("res://GameScreen/Field/Arrow.tscn")
const DIAMONDS_TEXTURE = preload("res://GameScreen/Suit/Diamonds.png")

# Available slots in row, column format
# top to bottom, left to right
var _slots = [
	[
		{
			reward = Reward.Nothing.new(),
			range = [Cards.Number.Ace, Cards.Number.King],
		},
		{
			reward = Reward.Points.new(2),
			range = [Cards.Number.Eight, Cards.Number.King],
		},
		{
			reward = Reward.Points.new(3),
			range = [Cards.Number.Ten, Cards.Number.King],
		},
		{
			reward = Reward.PlayAgain.new(),
			range = [Cards.Number.Jack, Cards.Number.King],
		},
		{
			range = [Cards.Number.Queen, Cards.Number.King],
			reward = Reward.Points.new(8),
		},
	], [
		{
			reward = Reward.Points.new(2),
			range = [Cards.Number.Ace, Cards.Number.Seven],
		},
		{
			reward = Reward.RedrawCard.new(),
			range = [Cards.Number.Five, Cards.Number.Nine],
		},
		{
			reward = Reward.Points.new(5),
			range = [Cards.Number.Eight, Cards.Number.Ten],
		},
		{
			reward = Reward.Points.new(8),
			range = [Cards.Number.Ten, Cards.Number.Jack],
		},
	], [
		{
			reward = Reward.PlayAgain.new(),
			range = [Cards.Number.Ace, Cards.Number.Four],
		},
		{
			reward = Reward.Points.new(5),
			range = [Cards.Number.Four, Cards.Number.Seven],
		},
		{
			reward = Reward.Points.new(13),
			range = [Cards.Number.Six, Cards.Number.Nine],
		},
	], [
		{
			reward = Reward.Points.new(5),
			range = [Cards.Number.Ace, Cards.Number.Three],
		},
		{
			reward = Reward.Points.new(5),
			range = [Cards.Number.Three, Cards.Number.Five],
		},
	], [
		{
			reward = Reward.Points.new(5),
			range = [Cards.Number.Ace, Cards.Number.Two],
		},
	],
]
## An array of [row, column] indexes in the slots grid that represent which 
## slots have been filled
# todo this could be removed by using slot.node.is_played instead
var _played_slots: Array[Vector2i] = []
## A reference to the TextureRect showing that this area belongs to the diamonds suit
var _suit_symbol


func _ready():
	# Wait for a frame for get_size() to return the correct values
	await get_tree().process_frame

	_spawn_slots()

	# The top-left slot is always filled when the game starts
	_played_slots.append(Vector2i(0, 0))

	# Also, that slot is not visible, instead there's a diamond symbol there
	_slots[0][0].node.visible = false
	_spawn_diamonds_symbol()


func can_play(number: Cards.Number) -> bool:
	return not _find_playable_slots(number).is_empty()


func play_suit(card_node: Card):
	# Move card to position of the suit symbol
	card_node.move_to(_suit_symbol.global_position + _suit_symbol.size * 0.5)


## Returns the reward gained by playing this card
func play_number(number: Cards.Number) -> Slot:
	var playable_slots = _find_playable_slots(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")

	# Mark slot as played
	var slot_position = playable_slots[0]
	_played_slots.append(slot_position)

	# Reset highlights
	highlight_options([])

	var slot = _slots[slot_position.y][slot_position.x]
	return slot.node


## Highlight slots that can be filled with one of the cards in card_types
func highlight_options(card_types: Array):
	# Reset all highlights
	for row in _slots:
		for slot in row:
			slot.node.is_highlighted = false

	# Highlight playable slots for each card type
	for card_type in card_types:
		var playable_slots = _find_playable_slots(card_type[1])
		if not playable_slots.is_empty():
			var slot_position = playable_slots[0]
			_slots[slot_position.y][slot_position.x].node.is_highlighted = true


func _spawn_slots():
	var x_padding = (size.x - (Slot.SIZE * GRID_COLUMNS)) / (GRID_COLUMNS - 1)
	var y_padding = (size.y - (Slot.SIZE * GRID_ROWS)) / (GRID_ROWS - 1)
	var row_index = 0
	for row in _slots:
		var col_index = 0

		for slot_spec in row:
			var node = SLOT_SCENE.instantiate()
			node.position.x = col_index * (Slot.SIZE + x_padding)
			node.position.y = row_index * (Slot.SIZE + y_padding)
			node.color = COLOR
			node.reward = slot_spec.reward
			node.text = "%s-%s" % [Cards.get_number_sigil(slot_spec.range[0]), Cards.get_number_sigil(slot_spec.range[1])]

			add_child(node)
			slot_spec.node = node

			var should_spawn_arrows = col_index < len(row) - 1
			if should_spawn_arrows:
				_spawn_arrow(Rect2(node.position + Vector2(Slot.SIZE, 0), Vector2(x_padding, Slot.SIZE)), false)

				_spawn_arrow(Rect2(node.position + Vector2(0, Slot.SIZE), Vector2(Slot.SIZE, y_padding)), true)
		
			col_index += 1

		row_index += 1


func _spawn_arrow(rect: Rect2, is_vertical: bool):
	var arrow = ARROW_SCENE.instantiate()
	arrow.size = rect.size
	arrow.position = rect.position
	arrow.color = COLOR
	arrow.is_vertical = is_vertical

	add_child(arrow)


## Instead of the top-left slot, we display a diamond symbol to show which suit this area is for
func _spawn_diamonds_symbol():
	_suit_symbol = TextureRect.new()
	_suit_symbol.texture = DIAMONDS_TEXTURE
	_suit_symbol.position = _slots[0][0].node.position
	_suit_symbol.ignore_texture_size = true
	_suit_symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(_suit_symbol)
	_suit_symbol.size = Vector2.ONE * Slot.SIZE


## Find slots that can be filled using a Diamonds card with the given number
func _find_playable_slots(number: Cards.Number) -> Array[Vector2i]:
	var playable_slots: Array[Vector2i] = []

	for row_index in len(_slots):
		var row = _slots[row_index]
		for col_index in len(row):
			var left_position = Vector2i(col_index - 1, row_index)
			var up_position = Vector2i(col_index, row_index - 1)
			var can_reach_position = left_position in _played_slots or up_position in _played_slots

			var slot_spec = row[col_index]
			var slot_position = Vector2i(col_index, row_index)
			if Cards.is_in_range(number, slot_spec.range) and \
					can_reach_position and not slot_position in _played_slots:
				playable_slots.append(slot_position)

	return playable_slots
	
