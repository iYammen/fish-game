extends Node
class_name spawnManager

@onready var monster_spawn_timer: Timer = $monsterSpawnTimer

const GUPPY = preload("res://scenes/Fish/guppy.tscn")
const MONSTER_1 = preload("res://scenes/monsters/monster_1.tscn")
var boundray: Vector2 = Vector2(500, 200)
@export var spawnNum: int = 5

func _ready() -> void:
	monster_spawn_timer.start(randf_range(1, 1))
	for guppy in spawnNum:
		var spawn: RigidBody2D = GUPPY.instantiate()
		get_tree().root.add_child.call_deferred(spawn)
		


func _on_monster_spawn_timer_timeout() -> void:
	var spawn: Area2D = MONSTER_1.instantiate()
	get_tree().root.add_child.call_deferred(spawn)
	monster_spawn_timer.start(randf_range(30, 60))
