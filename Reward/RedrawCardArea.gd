extends Control

# todo rename redraw bc of conflict with queue_redraw?

var redraw_count := 0:
	set(val):
		redraw_count = val
		queue_redraw()

var TEXTURE = preload("res://Reward/RedrawCard.svg")

func _ready():
	Events.consider_action.connect(self._consider_action)
	Events.choose_card.connect(self._choose_card)

func _consider_action(_card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.REDRAW:
		return

	var is_playable = redraw_count > 0
	mark_playable.call(is_playable)

func _choose_card(_card_type: Array, action: Events.Action) -> void:
	if action != Events.Action.REDRAW:
		return

	assert(redraw_count > 0, "Redraw triggered but user has no redraw tokens")
	redraw_count -= 1

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	for index in range(0, redraw_count):
		draw_texture(TEXTURE, Vector2(index * TEXTURE.get_size().x, center_y))