extends Node
class_name guppyManager
var boundray: Vector2 = Vector2(500, 200)

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-boundray.x, boundray.x), randf_range(-boundray.y, boundray.y))
	return targetPos
