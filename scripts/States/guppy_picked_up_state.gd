extends State

@export var fish: Guppy
var mouse_pos: Vector2
var target: Vector2
@onready var sprite_2d: Sprite2D = $"../../sprite2D"


func Enter() -> void:
	fish.freeze = true
	sprite_2d.scale = Vector2(1.5, 1.5)

func Update(_delta: float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(_delta: float):
	mouse_pos = fish.get_global_mouse_position()
	target = fish.global_position

	if mouse_pos.x > -183 and mouse_pos.x < 310:
		target.x = mouse_pos.x
	if mouse_pos.y > -170 and mouse_pos.y < 170:
		target.y = mouse_pos.y
	fish.global_position = target


func Exit():
	fish.freeze = false
	sprite_2d.scale = Vector2(1, 1)
