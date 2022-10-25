extends Node2D

const COLUMNS := 5
const ROWS := 5

const SLOT_SIZE := 90
var X_PADDING := 90
var Y_PADDING := 80

const SLOT_SCENE = preload("res://Diamonds/Slot.tscn")
const ARROW_SCENE = preload("res://Arrow.tscn")

const SLOTS = [
	[
		{
			reward = 0,
			right_arrow = [Cards.Number.Eight, Cards.Number.King],
			down_arrow = [Cards.Number.Ace, Cards.Number.Seven]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Jack, Cards.Number.King],
			down_arrow = [Cards.Number.Eight, Cards.Number.Ten]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Queen, Cards.Number.King],
			down_arrow = [Cards.Number.Ten, Cards.Number.Jack]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Queen, Cards.Number.King],
			down_arrow = [Cards.Number.Jack, Cards.Number.Queen]
		},
		{
			reward = 1,
		},
	], [
		{
			reward = 1,
			right_arrow = [Cards.Number.Five, Cards.Number.Seven],
			down_arrow = [Cards.Number.Ace, Cards.Number.Four]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Eight, Cards.Number.Nine],
			down_arrow = [Cards.Number.Six, Cards.Number.Seven]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Ten, Cards.Number.Jack],
			down_arrow = [Cards.Number.Nine, Cards.Number.Ten]
		},
		{
			reward = 1,
		},
	], [
		{
			reward = 1,
			right_arrow = [Cards.Number.Four, Cards.Number.Five],
			down_arrow = [Cards.Number.Ace, Cards.Number.Three]
		},
		{
			reward = 1,
			right_arrow = [Cards.Number.Seven, Cards.Number.Eight],
			down_arrow = [Cards.Number.Five, Cards.Number.Six]
		},
		{
			reward = 1,
		},
	], [
		{
			reward = 1,
			right_arrow = [Cards.Number.Three, Cards.Number.Four],
			down_arrow = [Cards.Number.Ace, Cards.Number.Two]
		},
		{
			reward = 1,
		},
	], [
		{
			reward = 1
		},
	],
]

## An array of [row, column] indexes in the SLOTS grid that represent which 
## slots have been filled
var played_slots: Array[Vector2i] = [Vector2i(0, 0)]

var color := ColorPalette.RED

func _ready():
	var row_index = 0
	for row in SLOTS:
		var col_index = 0

		for slot_spec in row:
			var slot = SLOT_SCENE.instantiate()
			slot.size = Vector2.ONE * SLOT_SIZE
			slot.position.x = col_index * (SLOT_SIZE + X_PADDING)
			slot.position.y = row_index * (SLOT_SIZE + Y_PADDING)
			slot.color = color
			add_child(slot)

			if slot_spec.has("right_arrow"):
				var x_number_range = slot_spec.right_arrow
				spawn_arrow(Rect2(slot.position + Vector2(SLOT_SIZE, 0), Vector2(X_PADDING, SLOT_SIZE)), false, x_number_range)

				if slot_spec.has("down_arrow"):
					var y_number_range = slot_spec.down_arrow
					spawn_arrow(Rect2(slot.position + Vector2(0, SLOT_SIZE), Vector2(SLOT_SIZE, Y_PADDING)), true, y_number_range)
		
			col_index += 1
		row_index += 1

func spawn_arrow(rect: Rect2, is_vertical, number_range):
	var arrow = ARROW_SCENE.instantiate()
	arrow.size = rect.size
	arrow.position = rect.position
	arrow.color = color
	arrow.is_vertical = is_vertical

	arrow.text = "%s-%s" % [Cards.get_number_sigil(number_range[0]), Cards.get_number_sigil(number_range[1])]
	add_child(arrow)

func can_play(card_type):
	var suite = card_type[0]
	var number = card_type[1]
	if suite != Cards.Suite.Diamonds:
		return false

	for position in played_slots:
		var x_allowed_range = SLOTS[position.y][position.x].get("right_arrow")
		var y_allowed_range = SLOTS[position.y][position.x].get("down_arrow")
		if Cards.is_in_range(number, x_allowed_range[0], x_allowed_range[1]) \
			or Cards.is_in_range(number, y_allowed_range[0], y_allowed_range[1]):
			return true
	
	return false
