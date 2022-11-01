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
