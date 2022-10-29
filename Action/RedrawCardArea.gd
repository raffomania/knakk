extends Control

# todo rename redraw bc of conflict with queue_redraw?

var redraw_tokens := 0:
	set(val):
		redraw_tokens = val
		queue_redraw()

var TEXTURE = preload("res://Action/RedrawCard.svg")

func _ready():
	Events.consider_action.connect(_consider_action)
	Events.choose_card.connect(_choose_card)

func _consider_action(_card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.REDRAW:
		return

	var is_playable = redraw_tokens > 0
	mark_playable.call(is_playable)

func _choose_card(_card_type: Array, action: Events.Action) -> void:
	if action != Events.Action.REDRAW:
		return

	assert(redraw_tokens > 0, "Redraw triggered but user has no redraw tokens")
	redraw_tokens -= 1

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	for index in range(0, redraw_tokens):
		draw_texture(TEXTURE, Vector2(index * TEXTURE.get_size().x, center_y), ColorPalette.GREY)