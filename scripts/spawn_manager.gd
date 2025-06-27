extends Node
class_name spawnManager

@onready var monster_spawn_timer: Timer = $monsterSpawnTimer
var warning: Control
const GUPPY = preload("res://scenes/Fish/guppy.tscn")
const MONSTER_1 = preload("res://scenes/monsters/monster_1.tscn")
var boundray: Vector2 = Vector2(500, 200)
@export var spawnNum: int = 5

func _ready() -> void:
	warning = get_tree().get_first_node_in_group("Warning UI")
	monster_spawn_timer.start(randf_range(120, 200))
	for guppy in spawnNum:
		var spawn: RigidBody2D = GUPPY.instantiate()
		get_tree().current_scene.add_child.call_deferred(spawn)
		
func _process(delta: float) -> void:
	if monster_spawn_timer.time_left < 5 and monster_spawn_timer.time_left > 1:
		warning.Show()
	elif monster_spawn_timer.time_left < 0.2:
		warning.Hide()

func _on_monster_spawn_timer_timeout() -> void:
	var spawn: Area2D = MONSTER_1.instantiate()
	get_tree().current_scene.add_child(spawn)
	monster_spawn_timer.start(randf_range(30, 60))
