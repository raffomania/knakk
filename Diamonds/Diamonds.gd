extends Node2D

const COLUMNS := 5
const ROWS := 5

const SLOT_SIZE := 90
var X_PADDING := 90
var Y_PADDING := 80

const SLOT_SCENE = preload("res://Diamonds/Slot.tscn")
const ARROW_SCENE = preload("res://Arrow.tscn")

var color := ColorPalette.RED

func _ready():
	for row_index in range(ROWS):
		# one less column for each row, to get a triangle:
		# 1 2 3
		# 1 2
		# 1
		var column_count = COLUMNS - row_index
		for col_index in range(column_count):
			var slot = SLOT_SCENE.instantiate()
			slot.size = Vector2.ONE * SLOT_SIZE
			slot.position.x = col_index * (SLOT_SIZE + X_PADDING)
			slot.position.y = row_index * (SLOT_SIZE + Y_PADDING)
			slot.color = color
			add_child(slot)

			if col_index < column_count - 1:
				var number_range = get_arrow_number_range(col_index, row_index, false)
				spawn_arrow(Rect2(slot.position + Vector2(SLOT_SIZE, 0), Vector2(X_PADDING, SLOT_SIZE)), false, number_range)

				if row_index < ROWS - 1:
					spawn_arrow(Rect2(slot.position + Vector2(0, SLOT_SIZE), Vector2(SLOT_SIZE, Y_PADDING)), true, number_range)

func spawn_arrow(rect: Rect2, is_vertical, number_range):
	var arrow = ARROW_SCENE.instantiate()
	arrow.size = rect.size
	arrow.position = rect.position
	arrow.color = color
	arrow.is_vertical = is_vertical

	arrow.text = "%s-%s" % [Cards.get_number_sigil(number_range[0]), Cards.get_number_sigil(number_range[1])]
	add_child(arrow)

func get_arrow_number_range(col_index, row_index, is_vertical):
	var n = Cards.Number
	var arrow_layout = [
		[[n.Eight, n.King], [n.Jack, n.King], [n.Queen, n.King], [n.Queen, n.King],],
		[[n.Ace, n.Seven], [n.Eight, n.Ten], [n.Ten, n.Jack], [n.Jack, n.Queen]],
		[[n.Five, n.Seven], [n.Eight, n.Nine], [n.Ten, n.Jack]],
		[[n.Ace, n.Four], [n.Six, n.Seven], [n.Nine, n.Ten]],
		[[n.Four, n.Five], [n.Seven, n.Eight]],
		[[n.Ace, n.Three], [n.Five, n.Six]],
		[[n.Three, n.Four]],
		[[n.Ace, n.Two]]
	]

	var arrow_row = row_index * 2

	if is_vertical:
		arrow_row += 1

	return arrow_layout[arrow_row][col_index]

func can_play(card_type):
	return card_type[0] == Cards.Suite.Diamonds
