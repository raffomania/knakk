extends Sprite2D

## The duration of the scaling animation in seconds
const SCALE_TWEEN_DURATION := 0.07
## The higher this number is, the faster the card follows the user's finger
const MOVEMENT_SMOOTHING_SPEED := 55.0

## Used to detect when users touch this card
@onready var touch_area: Area2D = $TouchDetectionArea

## Remember the original scale so we can reset to it after
## dragging stops
@onready var original_scale := self.scale

## Once users touch this card, this is set to `true`
## and subsequent drag events will move this card on the screen
var dragging := false

## Where on the card the user started dragging
var drag_offset := Vector2.ZERO

## The current position of the user's finger.
## in _process(), we interpolate the card position towards this position
@onready var target_drag_position := self.global_position

func _ready():
	touch_area.connect("input_event", self.area_input)

## Called when a user starts or stops touching this card
func area_input(_viewport, event, _shape_index):
	if event is InputEventScreenTouch:
		if event.pressed:
			# The user wants to drag this card somewhere
			self.dragging = true
			self.drag_offset = self.global_position - event.position
			self.target_drag_position = self.drag_offset + event.position
			create_tween().tween_property(self, "scale", original_scale * 1.1, SCALE_TWEEN_DURATION)
		else:
			# The user stopped dragging this card
			self.dragging = false
			create_tween().tween_property(self, "scale", original_scale, SCALE_TWEEN_DURATION)

## Called for all input events, regardless of the area they're touching
func _unhandled_input(event):
	if self.dragging and event is InputEventScreenDrag:
		self.target_drag_position = self.drag_offset + event.position

func _process(delta):
	# improved lerp smoothing to make drag motion less jittery
	# see https://www.gamedeveloper.com/programming/improved-lerp-smoothing- for an explanation of the formula
	self.global_position = self.target_drag_position.lerp(self.global_position, pow(2, -delta * MOVEMENT_SMOOTHING_SPEED))