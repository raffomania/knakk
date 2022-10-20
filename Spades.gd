extends Node2D

const COLUMNS := 5
const ROWS := 5

const SLOT_SIZE := 90
var X_PADDING := 90
var Y_PADDING := 80

const SLOT_SCENE = preload("res://Slot.tscn")
const ARROW_SCENE = preload("res://Arrow.tscn")

@export var color: Color

func _ready():
	for row_index in range(ROWS):
		# one less column for each row, to get a triangle:
		# 1 2 3
		# 1 2
		# 1
		var column_count = COLUMNS - row_index
		for col_index in range(column_count):
			var slot: Slot = SLOT_SCENE.instantiate()
			slot.size = Vector2.ONE * SLOT_SIZE
			slot.position.x = col_index * (SLOT_SIZE + X_PADDING)
			slot.position.y = row_index * (SLOT_SIZE + Y_PADDING)
			slot.color = color
			add_child(slot)

			if col_index < column_count - 1:
				var x_arrow = ARROW_SCENE.instantiate()
				x_arrow.size = Vector2(X_PADDING, SLOT_SIZE)
				x_arrow.position.x = col_index * (SLOT_SIZE + X_PADDING) + X_PADDING
				x_arrow.position.y = row_index * (SLOT_SIZE + Y_PADDING)
				x_arrow.color = color
				add_child(x_arrow)

				if row_index < ROWS - 1:
					var y_arrow = ARROW_SCENE.instantiate()
					y_arrow.size = Vector2(Y_PADDING, SLOT_SIZE)
					y_arrow.position.x = col_index * (SLOT_SIZE + X_PADDING) + X_PADDING
					# todo why does the X_PADDING at the end work here?
					y_arrow.position.y = row_index * (SLOT_SIZE + Y_PADDING) + X_PADDING
					y_arrow.rotation = PI / 2
					y_arrow.color = color
					add_child(y_arrow)

