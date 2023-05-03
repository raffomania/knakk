extends Camera2D


enum Screen {
	MENU,
	GAME,
}

var current_screen := Screen.MENU
var extra_zoom := Vector2.ONE
var zoom_wrapper := zoom
var extra_offset := Vector2.ZERO:
	set(val):
		extra_offset = val
		offset = offset_wrapper + val
var offset_wrapper := offset:
	set(val):
		offset_wrapper = val
		offset = val + extra_offset

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	# Use `extra_zoom` and `extra_offset` to make the 
	# playing field fit into the safe area.
	var safe_area = Rect2(DisplayServer.get_display_safe_area())
	var screen_size = Vector2(DisplayServer.screen_get_size())
	var relative_safe_size = safe_area.size / screen_size
	print("safe ratio ", relative_safe_size)
	var target_scale = min(relative_safe_size.x, relative_safe_size.y)
	extra_zoom = Vector2.ONE * target_scale

	var logical_viewport_size = Vector2(
		ProjectSettings.get("display/window/size/viewport_width"), 
		ProjectSettings.get("display/window/size/viewport_height"))
	var relative_offset = (safe_area.get_center() / screen_size) - (Vector2.ONE * 0.5)
	extra_offset = -relative_offset * logical_viewport_size / target_scale
	print("extra offset ", extra_offset)


func _process(_dt):
	zoom = extra_zoom * zoom_wrapper


func go_to_game_screen():
	match current_screen:
		Screen.MENU:
			animation_player.play("menu_to_game")

	current_screen = Screen.GAME
	await animation_player.animation_finished


func go_to_menu_screen():
	match current_screen:
		Screen.GAME:
			animation_player.play_backwards("menu_to_game")

	current_screen = Screen.MENU
	await animation_player.animation_finished
