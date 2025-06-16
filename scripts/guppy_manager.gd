extends Node
class_name guppyManager

const GUPPY = preload("res://scenes/guppy.tscn")
var boundray: Vector2 = Vector2(500, 200)
var spawnNum: int = 5

func _ready() -> void:
	for guppy in spawnNum:
		var spawn: RigidBody2D = GUPPY.instantiate()
		get_tree().root.add_child.call_deferred(spawn)
		

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-boundray.x, boundray.x), randf_range(-boundray.y, boundray.y))
	return targetPos
