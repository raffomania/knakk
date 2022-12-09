@tool
extends Control


const BACKGROUND = preload("res://Reward/Reward.svg")
const REDRAW_TEXTURE = preload("res://GameScreen/Action/RedrawCard.svg")

var reward:
	set = set_reward

@export var color := Color.BLACK:
	set(val):
		color = val
		queue_redraw()

@onready var animation_player = $AnimationPlayer


func _ready():
	# Always scale and rotate around the center
	pivot_offset = size / 2

	($Label as Label).add_theme_font_size_override("font_size", floor(size.x * 0.5))
	($Label as Label).add_theme_font_override("font", preload("res://Fonts/Dosis-Bold.ttf"))


func _draw():
	draw_texture_rect(BACKGROUND,
		Rect2(Vector2.ZERO, size),
		false, color
	)

	if reward is Reward.RedrawCard:
		var padding = size * 0.4
		draw_texture_rect(REDRAW_TEXTURE, 
			Rect2(Vector2.ZERO + padding / 2, size - padding), 
			false, ColorPalette.WHITE
		)

func set_reward(value: Reward):
	var points_changed = (
		reward is Reward.Points 
		and value is Reward.Points 
		and reward.points != value.points
	)
	reward = value
	queue_redraw()

	# Reset to initial state
	visible = true
	$Label.visible = true

	# Depending on reward, set label text, hide the marker completely, or hide only the label
	if reward is Reward.Points:
		$Label.text = str(reward.points)
	elif reward is Reward.PlayAgain:
		$Label.text = "++"
	elif reward is Reward.Nothing:
		visible = false
	elif reward is Reward.RedrawCard:
		$Label.visible = false

	# When this node is used to show a score, animate it when the score changes.
	if is_inside_tree() and points_changed and not animation_player.is_playing():
		animation_player.play("blink")
