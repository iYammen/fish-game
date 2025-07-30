extends Camera2D
var shake_timer := 0.0
var shake_magnitude := 0.0
var original_position := Vector2.ZERO

func _ready():
	original_position = position

func screenShake(magnitude: float, duration: float = 0.3):
	shake_magnitude = magnitude
	shake_timer = duration

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		position = original_position + Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
	else:
		position = original_position
