extends Control

@onready var texture_rect: TextureRect = $TextureRect
@export var textures: Array[Texture2D]

func random():
	texture_rect.modulate = _generate_random_hsv_color()
	texture_rect.texture = textures[randi_range(0, textures.size() - 1)]

func _generate_random_hsv_color() -> Color:
	return Color.from_hsv(
	randf(), # HUE
	randf_range(0.2, 0.6), # SATURATION
	randf_range(0.9, 1.0), # BRIGHTNESS
	)
