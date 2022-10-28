extends Node2D

const COLUMNS := 5
const ROWS := 5

const SLOT_SIZE := 90
var X_PADDING := 90
var Y_PADDING := 80

const SLOT_SCENE = preload("res://Slot/Slot.tscn")
const ARROW_SCENE = preload("res://Diamonds/Arrow.tscn")

var slots = [
	[
		{
			reward = Reward.Nothing.new(),
			right_arrow = [Cards.Number.Eight, Cards.Number.King],
			down_arrow = [Cards.Number.Ace, Cards.Number.Seven]
		},
		{
			reward = Reward.RedrawCard.new(),
			right_arrow = [Cards.Number.Jack, Cards.Number.King],
			down_arrow = [Cards.Number.Eight, Cards.Number.Ten]
		},
		{
			reward = Reward.RedrawCard.new(),
			right_arrow = [Cards.Number.Queen, Cards.Number.King],
			down_arrow = [Cards.Number.Ten, Cards.Number.Jack]
		},
		{
			reward = Reward.Points.new(5),
			right_arrow = [Cards.Number.Queen, Cards.Number.King],
			down_arrow = [Cards.Number.Jack, Cards.Number.Queen]
		},
		{
			reward = Reward.Points.new(8),
		},
	], [
		{
			reward = Reward.Points.new(1),
			right_arrow = [Cards.Number.Five, Cards.Number.Seven],
			down_arrow = [Cards.Number.Ace, Cards.Number.Four]
		},
		{
			reward = Reward.Points.new(2),
			right_arrow = [Cards.Number.Eight, Cards.Number.Nine],
			down_arrow = [Cards.Number.Six, Cards.Number.Seven]
		},
		{
			reward = Reward.Points.new(1),
			right_arrow = [Cards.Number.Ten, Cards.Number.Jack],
			down_arrow = [Cards.Number.Nine, Cards.Number.Ten]
		},
		{
			reward = Reward.Points.new(8),
		},
	], [
		{
			reward = Reward.Points.new(3),
			right_arrow = [Cards.Number.Four, Cards.Number.Five],
			down_arrow = [Cards.Number.Ace, Cards.Number.Three]
		},
		{
			reward = Reward.Points.new(1),
			right_arrow = [Cards.Number.Seven, Cards.Number.Eight],
			down_arrow = [Cards.Number.Five, Cards.Number.Six]
		},
		{
			reward = Reward.Points.new(1),
		},
	], [
		{
			reward = Reward.Points.new(8),
			right_arrow = [Cards.Number.Three, Cards.Number.Four],
			down_arrow = [Cards.Number.Ace, Cards.Number.Two]
		},
		{
			reward = Reward.Points.new(8),
		},
	], [
		{
			reward = Reward.Points.new(8),
		},
	],
]

## An array of [row, column] indexes in the slots grid that represent which 
## slots have been filled
var played_slots: Array[Vector2i] = []

var color := ColorPalette.RED

func _ready():
	spawn_slots()

	# The top-left slot is always filled when the game starts
	slots[0][0].node.is_played = true
	played_slots.append(Vector2i(0, 0))

func spawn_slots() -> void:
	var row_index = 0
	for row in slots:
		var col_index = 0

		for slot_spec in row:
			var node = SLOT_SCENE.instantiate()
			node.size = Vector2.ONE * SLOT_SIZE
			node.position.x = col_index * (SLOT_SIZE + X_PADDING)
			node.position.y = row_index * (SLOT_SIZE + Y_PADDING)
			node.color = color
			if slot_spec.reward is Reward.Points:
				node.text = str(slot_spec.reward.points)
			add_child(node)
			slot_spec.node = node

			if slot_spec.has("right_arrow"):
				var x_number_range = slot_spec.right_arrow
				spawn_arrow(Rect2(node.position + Vector2(SLOT_SIZE, 0), Vector2(X_PADDING, SLOT_SIZE)), false, x_number_range)

				if slot_spec.has("down_arrow"):
					var y_number_range = slot_spec.down_arrow
					spawn_arrow(Rect2(node.position + Vector2(0, SLOT_SIZE), Vector2(SLOT_SIZE, Y_PADDING)), true, y_number_range)
		
			col_index += 1
		row_index += 1

func spawn_arrow(rect: Rect2, is_vertical: bool, number_range) -> void:
	var arrow = ARROW_SCENE.instantiate()
	arrow.size = rect.size
	arrow.position = rect.position
	arrow.color = color
	arrow.is_vertical = is_vertical

	arrow.text = "%s-%s" % [Cards.get_number_sigil(number_range[0]), Cards.get_number_sigil(number_range[1])]
	add_child(arrow)

func can_play(number: Cards.Number) -> bool:
	var playable_slots = find_slots_to_play(number)
	
	return not playable_slots.is_empty()

## Returns the reward gained by playing this card
func play_card(number: Cards.Number) -> Reward:
	var playable_slots = find_slots_to_play(number)
	assert(not playable_slots.is_empty(), "Player managed to play a card that cannot be played")
	var slot_position = playable_slots[0]
	played_slots.append(slot_position)
	var slot = slots[slot_position.y][slot_position.x]
	slot.node.is_played = true
	highlight_options([])
	return slot.reward

func highlight_options(card_types: Array) -> void:
	for row in slots:
		for slot in row:
			slot.node.is_highlighted = false

	for card_type in card_types:
		for slot_position in find_slots_to_play(card_type[1]):
			slots[slot_position.y][slot_position.x].node.is_highlighted = true

func find_slots_to_play(number: Cards.Number) -> Array[Vector2i]:
	var playable_slots: Array[Vector2i] = []
	for slot_position in played_slots:
		var right_range = slots[slot_position.y][slot_position.x].get("right_arrow")
		var down_range = slots[slot_position.y][slot_position.x].get("down_arrow")

		var right_position = Vector2i(slot_position.x + 1, slot_position.y) 
		if right_range != null and \
				Cards.is_in_range(number, right_range) and \
				not right_position in played_slots:
			playable_slots.append(right_position)

		var down_position = Vector2i(slot_position.x, slot_position.y + 1)
		if down_range != null and \
				Cards.is_in_range(number, down_range) and \
				not down_position in played_slots:
			playable_slots.append(down_position)

	return playable_slots
	
