extends Control

const BACKGROUND = preload("res://Reward/Reward.svg")
const REDRAW_TEXTURE = preload("res://Action/RedrawCard.svg")

var color := Color.BLACK:
	set(val):
		color = val
		$TextureRect.modulate = color

var reward:
	set(val):
		reward = val
		$TextureRect.visible = true
		queue_redraw()

		if reward is Reward.Points:
			$Label.text = str(val.points)
		elif reward is Reward.PlayAgain:
			$Label.text = "+1"
		elif reward is Reward.Nothing:
			$Label.text = ""
			$TextureRect.visible = false

func _draw():
	if reward is Reward.RedrawCard:
		draw_texture_rect(REDRAW_TEXTURE, Rect2(Vector2.ZERO, size), false, ColorPalette.WHITE)
