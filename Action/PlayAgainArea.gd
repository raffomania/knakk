extends Control

var play_again_tokens := 0:
	set(val):
		play_again_tokens = val
		queue_redraw()

func _ready():
	Events.consider_action.connect(_consider_action)
	Events.choose_card.connect(_choose_card)

func _consider_action(_card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.PLAY_AGAIN:
		return

	var is_playable = play_again_tokens > 0
	mark_playable.call(is_playable)

func _choose_card(_card_type: Array, action: Events.Action) -> void:
	if action != Events.Action.PLAY_AGAIN:
		return

	assert(play_again_tokens > 0, "PlayAgain triggered but user has no play again tokens")
	play_again_tokens -= 1

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2.ZERO, Vector2(0, size.y), ColorPalette.PURPLE)

	for index in range(0, play_again_tokens):
		draw_string(
			get_theme_default_font(), 
			Vector2(20 + index * 40, 70), 
			"+1", 0, -1, 
			round(get_theme_default_font_size() * 1.3), 
			get_theme_color("Label"))
