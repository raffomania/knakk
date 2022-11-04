@tool
extends Control

const BACKGROUND = preload("res://Reward/Reward.svg")
const REDRAW_TEXTURE = preload("res://Action/RedrawCard.svg")

var color := Color.BLACK:
	set(val):
		color = val
		queue_redraw()

var reward:
	set(val):
		var reward_changed = (
			reward is Reward.Points 
			and val is Reward.Points 
			and reward.points != val.points
		)
		reward = val
		queue_redraw()

		# Reset to initial state
		visible = true
		$Label.visible = true

		# Depending on reward, set label text, hide the marker completely, or hide only the label
		if reward is Reward.Points:
			$Label.text = str(val.points)
		elif reward is Reward.PlayAgain:
			$Label.text = "+1"
		elif reward is Reward.Nothing:
			visible = false
		elif reward is Reward.RedrawCard:
			$Label.visible = false

		# When this node is used to show a score, animate it when the score changes.
		if is_inside_tree() and reward_changed:
			await create_tween() \
				.tween_property(self, "scale", Vector2.ONE * 1.05, 0.05) \
				.finished
			var _tweener = create_tween() \
				.tween_property(self, "scale", Vector2.ONE, 0.05)

func _ready():
	# Always scale and rotate around the center
	pivot_offset = size / 2

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
