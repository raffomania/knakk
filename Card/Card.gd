class_name Card
extends Sprite2D


## The duration of the scaling animation in seconds
const SCALE_TWEEN_DURATION := 0.07
## The higher this number is, the faster the card follows the user's finger
const DRAG_SMOOTH_SPEED := 65.0
## Same as `DRAG_SMOOTH_SPEED`, but used when the user is not actively dragging
const ANIMATE_SMOOTH_SPEED := 15.0
## The card's normal scale when it's not being dragged
const NORMAL_SCALE := Vector2(0.85, 0.85)
## The card's scale while being dragged
const DRAGGING_SCALE := Vector2(0.9, 0.9)
## The card's rotation while being dragged
const DRAGGING_ROTATION := PI / 35
## The card's scale while the player is hovering over an action area
const ACTION_SCALE := Vector2(1, 1)
## The card's scale while the player is hovering over an action area
const PLAYED_SCALE := Vector2(0.8, 0.8)

## Once users touch this card, this is set to `true`
## and subsequent drag events will move this card on the screen
var is_dragging := false
## Once users move the card into the confirmation area,
## the card will light up. If the player drops the card while
## in that zone, the card is chosen and the "choose" signal
## is emitted.
var considering_action := Events.Action.NOTHING:
	set = _set_considering_action
## When players are considering this card,
## The playing field will set this value depending on
## whether the player can play this card or not
var can_play := false:
	set(val):
		can_play = val
		_visualize_interaction_state()
## Once the card is played, it cannot be played again.
var is_played := false
## Where on the card the user started dragging
var drag_offset := Vector2.ZERO
## The value of this card.
## Stored as a [suite, number] array.
# todo rename to card_value everywhere?
var card_type: Array

## Global position that this card had in the deck,
## used to move the card back if the player doesn't choose it for playing
@onready var starting_position := self.global_position
## The current position of the user's finger.
## in _process(), we interpolate the card position towards this position
@onready var target_drag_position := self.global_position


func _ready():
	Events.card_types_in_hand.append(card_type)
	_visualize_interaction_state()
	var _err = Events.consider_action.connect(_on_consider_action)
	_err = Events.cancel_consider_action.connect(_on_cancel_consider_action)


func _exit_tree():
	Events.card_types_in_hand.erase(card_type)


## Detect when a user starts or stops touching this card
func _input(event: InputEvent):
	if is_played: return

	if event is InputEventScreenTouch:
		if not event.pressed and is_dragging:
			_stop_dragging()
		elif event.pressed and get_rect().has_point(make_input_local(event).position):
			_start_dragging(event.position)
		else:
			# Nothing to do
			return

		_visualize_interaction_state()

		# This event is handled by this card, stop it from bubbling to other cards
		get_viewport().set_input_as_handled()

	if is_dragging and event is InputEventScreenDrag:
		_drag(event.position)

func _draw():
	if considering_action != Events.Action.NOTHING and can_play:
		var size = self.texture.get_size() * 1.05
		draw_rect(Rect2(-size/2, size), ColorPalette.PURPLE, false, 5.0)


func _process(delta: float):
	var smooth_speed = DRAG_SMOOTH_SPEED if is_dragging else ANIMATE_SMOOTH_SPEED
	# improved lerp smoothing to make drag motion less jittery
	# see https://www.gamedeveloper.com/programming/improved-lerp-smoothing- for an explanation of the formula
	self.global_position = self.target_drag_position.lerp(self.global_position, pow(2, -delta * smooth_speed))


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


## When the card is played, it is usually placed on the field somewhere.
## For that, animate it to shrink and rotate a little randomly.
func shrink_to_played_size():
	var target_scale = 120 / texture.get_size().x
	var _tweener = create_tween().tween_property(self, "scale", Vector2.ONE * target_scale, 0.3)
	var new_rotation = PI * 0.1 * randf_range(-1, 1)
	var tweener = create_tween().tween_property(self, "rotation", new_rotation, 0.35)
	await tweener.finished


func animate_disappear():
	var tweener = create_tween().tween_property(self, "scale", Vector2(0, scale.y), 0.2)
	await tweener.finished


## If another card is considering to skip this round (because no moves are possible),
## move this card to the top to indicate that it will be discarded as well.
func _on_consider_action(_card_type: Array, action: Events.Action):
	if action != Events.Action.SKIP_ROUND:
		return

	if is_dragging or is_played:
		return

	move_to(starting_position - Vector2(0, 500))


## If the player was considering to skip this round, move this card back
## to its position in the hand
func _on_cancel_consider_action(action: Events.Action):
	if action != Events.Action.SKIP_ROUND:
		return

	if is_dragging or is_played:
		return

	move_to(starting_position)


## The user has started touching this card and wants to drag it
func _start_dragging(touch_position: Vector2):
	is_dragging = true
	drag_offset = global_position - touch_position
	# If the card is just returning to the hand, cancel that motion immediately
	move_to(global_position)


## The user stopped dragging this card
func _stop_dragging():
	is_dragging = false
	var was_considering_action = considering_action != Events.Action.NOTHING
	if was_considering_action and can_play:
		Events.take_action.emit(card_type, considering_action, self)
		considering_action = Events.Action.NOTHING
		queue_redraw()
		Events.show_help.emit("")
	else:
		if was_considering_action:
			Events.cancel_consider_action.emit(considering_action)
			Events.show_help.emit("")

		move_to(starting_position)
		considering_action = Events.Action.NOTHING
		queue_redraw()


func _drag(to_position: Vector2):
	target_drag_position = drag_offset + to_position

	if target_drag_position.x < 300 and target_drag_position.y > 2200:
		considering_action = Events.Action.REDRAW
	elif target_drag_position.x > 800 and target_drag_position.y > 2200:
		considering_action = Events.Action.PLAY_AGAIN
	elif target_drag_position.y < 1700:
		considering_action = Events.Action.CHOOSE
	else:
		considering_action = Events.Action.NOTHING
		can_play = false

	_visualize_interaction_state()
	queue_redraw()


func _set_considering_action(new_considering_action: Events.Action):
	var previously_considering_action = considering_action
	considering_action = new_considering_action

	if previously_considering_action == considering_action:
		# Nothing changed, nothing to do
		return

	if considering_action == Events.Action.NOTHING:
		Events.cancel_consider_action.emit(previously_considering_action)
		Events.show_help.emit("")

		return

	can_play = Events.is_playable(card_type, considering_action)

	# If we can't play any action this turn, change the action to `SKIP_ROUND`
	# and emit that instead
	if (considering_action == Events.Action.CHOOSE 
			and not can_play 
			and _need_to_skip_round()):
		considering_action = Events.Action.SKIP_ROUND
		# Since we've changed the action to `SKIP_ROUND`, we know we are allowed to
		# play it
		can_play = true
		Events.show_help.emit("No moves possible with your hand - Discard cards and move to next turn")

	# Notify other nodes of the action being considered
	Events.consider_action.emit(card_type, considering_action)


## Update scale and rotation to indicate what the player is doing with this card at the moment
func _visualize_interaction_state():
	if considering_action != Events.Action.NOTHING and can_play:
		var _tweener = create_tween().tween_property(self, "scale", ACTION_SCALE, SCALE_TWEEN_DURATION)
	elif is_dragging:
		var _tweener = create_tween().tween_property(self, "scale", DRAGGING_SCALE, SCALE_TWEEN_DURATION)
		_tweener = create_tween().tween_property(self, "rotation", DRAGGING_ROTATION, SCALE_TWEEN_DURATION)
	else:
		var _tweener = create_tween().tween_property(self, "scale", NORMAL_SCALE, SCALE_TWEEN_DURATION)
		_tweener = create_tween().tween_property(self, "rotation", 0, SCALE_TWEEN_DURATION)


## Sometimes, it's impossible to make any move with a given hand.
## If that's the case, the player has to discard their hand and move on to the
## next round.
## This method detects when this shoud happen.
func _need_to_skip_round() -> bool:
	var result = true

	for other_card_type in Events.card_types_in_hand:
		result = result and not Events.is_playable(other_card_type, Events.Action.CHOOSE)
		result = result and not Events.is_playable(other_card_type, Events.Action.REDRAW)

	return result
