extends Node2D

class_name Slot

@onready var label := $Label

@export var size := Vector2(50, 50):
	set(value):
		size = value
		if is_instance_valid(label):
			label.size = size

@export var color := Color.BLACK

func _ready():
	label.size = size

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), color, false, 2.0)
