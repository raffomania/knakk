@tool
class_name RewardMarker extends Control


const BACKGROUND = preload("res://Reward/Reward.svg")
const REDRAW_TEXTURE = preload("res://GameScreen/Action/RedrawCard.svg")

var reward:
	set = set_reward

## When the points for this reward change, an animation is played to indicate
## the change. This property determines the speed of that animation.
var animation_speed := 1.0

@export var color := Color.BLACK:
	set(val):
		color = val
		queue_redraw()

@onready var animation_player = $AnimationPlayer


func _ready():
	self.resized.connect(_on_resize)
	_on_resize()
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
		animation_player.play("blink", -1, animation_speed)


func _on_resize():
	# Always scale and rotate around the center
	pivot_offset = size / 2
	# Adapt font to size
	($Label as Label).add_theme_font_size_override("font_size", floor(size.x * 0.5))


func tween_to_large_center():
	var center_highlight_size = size * 3
	var center_position = Util.get_camera_bounds().get_center() - center_highlight_size / 2

	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "global_position", center_position, .8).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "size", center_highlight_size, .6).set_ease(Tween.EASE_OUT)

	var scale_tween = create_tween().set_trans(Tween.TRANS_EXPO)
	scale_tween.tween_property(self, "scale", Vector2(0, 1), .2).set_ease(Tween.EASE_IN)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .4).set_ease(Tween.EASE_OUT)

	await tween.finished


## Animate the marker to move to the given position in a cool arc motion.
## Used when a slot is filled and the reward is added to the score or bonus areas.
func tween_to_position(global_target: Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "global_position", global_target, .5).set_ease(Tween.EASE_IN)

	await tween.finished


func tween_to_size(target_size: Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "size", target_size, .4).set_ease(Tween.EASE_IN)

	await tween.finished
