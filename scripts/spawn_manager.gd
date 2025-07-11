extends Node
class_name spawnManager

var spawnPos: Vector2
var spawned: bool = false
const SPAWN_POINT_UI = preload("res://scenes/UI/spawn_point_ui.tscn")
@onready var monster_spawn_timer: Timer = $monsterSpawnTimer
@export var monsterSpawnTimerRange: Vector2
var warning: Control
const GUPPY = preload("res://scenes/Fish/guppy.tscn")
const MONSTER_1 = preload("res://scenes/monsters/monster_1.tscn")
const SHARK = preload("res://scenes/Fish/shark.tscn")
const CRAB = preload("res://scenes/Fish/Crab.tscn")
const ALGAE = preload("res://scenes/algae.tscn")
var boundray: Vector2 = Vector2(500, 200)
@export var spawnNum: int = 5
var game_manager: GameManager


func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	monster_spawn_timer.start(randf_range(monsterSpawnTimerRange.x, monsterSpawnTimerRange.y))
	for guppy in spawnNum:
		var spawn:= GUPPY.instantiate()
		get_tree().current_scene.add_child.call_deferred(spawn)
		spawn.global_position = game_manager.GetDirection()

	warning = get_tree().get_first_node_in_group("Warning UI")

func _process(_delta: float) -> void:
	if monster_spawn_timer.time_left < 5 and monster_spawn_timer.time_left > 0.5 and !spawned:
		spawnPos = game_manager.GetDirection()
		var ins = SPAWN_POINT_UI.instantiate()
		get_tree().current_scene.add_child(ins)
		ins.global_position = spawnPos
		warning.ShowAll()
		spawned = true
	elif monster_spawn_timer.time_left < 0.2:
		warning.Hide()

func _on_monster_spawn_timer_timeout() -> void:
	var spawn: Area2D = MONSTER_1.instantiate()
	get_tree().current_scene.add_child(spawn)
	spawn.global_position = spawnPos
	monster_spawn_timer.start(randf_range(monsterSpawnTimerRange.x, monsterSpawnTimerRange.y))
	spawned = false
