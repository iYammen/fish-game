extends Node
class_name spawnManager

var spawnPos: Vector2
var spawned: bool = false
const SPAWN_POINT_UI = preload("res://scenes/UI/spawn_point_ui.tscn")
@onready var monster_spawn_timer: Timer = $monsterSpawnTimer
@export var monsterSpawnTimerRange: Vector2
@export var monsters: Array[PackedScene]
var warning: Control
const GUPPY = preload("res://scenes/Fish/guppy.tscn")
const SHARK = preload("res://scenes/Fish/shark.tscn")
const CRAB = preload("res://scenes/Fish/Crab.tscn")
const ALGAE = preload("res://scenes/algae.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
var boundray: Vector2 = Vector2(500, 200)
@export var spawnNum: int = 5
var game_manager: GameManager
var monsterToSpawn: int

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
		pickMonster()
		var ins = SPAWN_POINT_UI.instantiate()
		get_tree().current_scene.add_child(ins)
		ins.global_position = spawnPos
		ins.setTimer(monster_spawn_timer.time_left)
		warning.ShowAll()
		spawned = true
	elif monster_spawn_timer.time_left < 0.2:
		warning.Hide()

func pickMonster():
	if game_manager.stage <= 1:
		monsterToSpawn = 0
	else:
		monsterToSpawn = randi_range(0,1)
	
	match monsterToSpawn:
		0:
			spawnPos = game_manager.GetDirection()
		1:
			spawnPos.x = game_manager.GetDirection().x
			spawnPos.y = 128.0

func spawnMonster():
	var spawn:= monsters[monsterToSpawn].instantiate()
	get_tree().current_scene.add_child(spawn)
	spawn.global_position = spawnPos
	monster_spawn_timer.start(randf_range(monsterSpawnTimerRange.x, monsterSpawnTimerRange.y))
	spawned = false

func riseSpawnRate():
	if  monsterSpawnTimerRange.x > 5 or monsterSpawnTimerRange.y > 10:
		monsterSpawnTimerRange -= Vector2(1, 1)
		print(monsterSpawnTimerRange)

func _on_monster_spawn_timer_timeout() -> void:
	spawnMonster()
