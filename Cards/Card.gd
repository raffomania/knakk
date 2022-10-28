extends Sprite2D

# todo dragging fast while releasing doesn't return the card to its original position

## The duration of the scaling animation in seconds
const SCALE_TWEEN_DURATION := 0.07
## The higher this number is, the faster the card follows the user's finger
const DRAG_SMOOTH_SPEED := 55.0
## Same as `DRAG_SMOOTH_SPEED`, but used when the user is not actively dragging
const ANIMATE_SMOOTH_SPEED := 15.0

## Used to detect when users touch this card
@onready var touch_area: Area2D = $TouchDetectionArea

## Remember the original scale so we can reset to it after
## dragging stops
@onready var original_scale := self.scale

## Once users touch this card, this is set to `true`
## and subsequent drag events will move this card on the screen
var dragging := false

## Once users move the card into the confirmation area,
## the card will light up. If the player drops the card while
## in that zone, the card is chosen and the "choose" signal
## is emitted.
var is_considering := false

## When players are considering this card,
## The playing field will set this value depending on
## whether the player can play this card or not
var can_play := false

## Where on the card the user started dragging
var drag_offset := Vector2.ZERO

## Global position that this card had in the deck,
## used to move the card back if the player doesn't choose it for playing
@onready var starting_position := self.global_position

## The current position of the user's finger.
## in _process(), we interpolate the card position towards this position
@onready var target_drag_position := self.global_position

## The value of this card.
## Stored as a [suite, number] array.
# todo rename to card_value everywhere?
var card_type: Array

func _ready():
	touch_area.connect("input_event", self.area_input)
	Events.card_types_in_hand.append(card_type)

## Called when a user starts or stops touching this card
func area_input(_viewport, event, _shape_index):
	if event is InputEventScreenTouch:
		if event.pressed:
			# The user wants to drag this card somewhere
			self.dragging = true
			self.drag_offset = self.global_position - event.position
			# If the card is just returning to the hand, cancel that motion immediately
			self.move_to(self.global_position)
			create_tween().tween_property(self, "scale", Vector2.ONE, SCALE_TWEEN_DURATION)
		else:
			# The user stopped dragging this card
			self.dragging = false
			if is_considering and can_play:
				Events.choose_card.emit(card_type)
				Events.card_types_in_hand.erase(card_type)
				queue_free()
			else:
				if is_considering:
					Events.cancel_consider_card.emit()
				self.move_to(self.starting_position)
				create_tween().tween_property(self, "scale", original_scale, SCALE_TWEEN_DURATION)

## Called for all input events, regardless of the area they're touching
func _unhandled_input(event):
	if dragging and event is InputEventScreenDrag:
		target_drag_position = drag_offset + event.position

		if target_drag_position.y < 1300:
			if not is_considering:
				Events.consider_card.emit(card_type)
			is_considering = true
			queue_redraw()
		else:
			if is_considering:
				Events.cancel_consider_card.emit()
			is_considering = false
			queue_redraw()

## Tell this card to transition to a new position.
## The transition is animated.
func move_to(new_global_position: Vector2):
	self.target_drag_position = new_global_position

## Set the card type for this card.
## Will automatically set the new texture for that card type.
## Expects an array of [suite, number] as the card_type argument
func set_card_type(new_card_type: Array):
	self.card_type = new_card_type
	self.texture = Cards.textures[self.card_type[0]][self.card_type[1]]

func _draw():
	if is_considering and can_play:
		var size = self.texture.get_size() * 1.05
		draw_rect(Rect2(-size/2, size), ColorPalette.PURPLE, false, 5.0)

func _process(delta):
	var smooth_speed = DRAG_SMOOTH_SPEED if self.dragging else ANIMATE_SMOOTH_SPEED
	# improved lerp smoothing to make drag motion less jittery
	# see https://www.gamedeveloper.com/programming/improved-lerp-smoothing- for an explanation of the formula
	self.global_position = self.target_drag_position.lerp(self.global_position, pow(2, -delta * smooth_speed))
