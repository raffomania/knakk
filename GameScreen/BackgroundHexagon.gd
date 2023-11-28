extends TextureRect


func _ready():
	pivot_offset = size / 2
	scale = Vector2(0, 1)
	await get_tree().create_timer(randf() * 0.8).timeout
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.15)