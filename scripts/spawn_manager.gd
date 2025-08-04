extends Node
class_name spawnManager

var spawnPos: Array[Vector2] = [Vector2(0,0)]
var spawned: bool = false
const SPAWN_POINT_UI = preload("res://scenes/UI/spawn_point_ui.tscn")
@onready var monster_spawn_timer: Timer = $monsterSpawnTimer
@export var monsterSpawnTimerRange: Vector2
@export var monsters: Array[PackedScene]
var warning: Control
const GUPPY = preload("res://scenes/Fish/guppy.tscn")
const BLOOD_DIAMOND = preload("res://scenes/bloodDiamond.tscn")
const SHARK = preload("res://scenes/Fish/shark.tscn")
const MONSTER_1 = preload("res://scenes/monsters/monster_1.tscn")
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
@export var spawnNum: int = 1
var game_manager: GameManager
var monsterToSpawn: Array[int] = [0]
var monsterSpawnNum: int = 1
var camera: Camera2D

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	camera = game_manager.camera
	monster_spawn_timer.start(randf_range(monsterSpawnTimerRange.x, monsterSpawnTimerRange.y))
	for guppy in spawnNum:
		var spawn:= GUPPY.instantiate()
		get_tree().current_scene.add_child.call_deferred(spawn)
		spawn.global_position = game_manager.GetDirection()

	warning = get_tree().get_first_node_in_group("Warning UI")

func _process(_delta: float) -> void:
	if monster_spawn_timer.time_left < 5 and monster_spawn_timer.time_left > 0.5 and !spawned:
		AudioManager.OceanMusicToDarkMusic()
		print(monsterToSpawn)
		for i in monsterSpawnNum:
			pickMonster(i)
			var ins = SPAWN_POINT_UI.instantiate()
			get_tree().current_scene.add_child(ins)
			ins.global_position = spawnPos[i]
			ins.setTimer(monster_spawn_timer.time_left)
			warning.ShowAll()
			AudioManager.playError()
		spawned = true
	elif monster_spawn_timer.time_left < 0.2:
		warning.Hide()

func pickMonster(monsterNum):
	if game_manager.stage <= 1:
		monsterToSpawn[monsterNum] = 0
	else:
		monsterToSpawn[monsterNum] = randi_range(0,1)
	
	match monsterToSpawn[monsterNum]:
		0:
			spawnPos[monsterNum] = game_manager.GetDirection()
		1:
			spawnPos[monsterNum].x = game_manager.GetDirection().x
			spawnPos[monsterNum].y = 128.0

func spawnMonster():
	camera.screenShake(2, 0.2)
	AudioManager.playEnemySpawn()
	for i in monsterSpawnNum:
		var spawn:= monsters[monsterToSpawn[i]].instantiate()
		get_tree().current_scene.add_child(spawn)
		spawn.global_position = spawnPos[i]
		monster_spawn_timer.start(randf_range(monsterSpawnTimerRange.x, monsterSpawnTimerRange.y))
		spawned = false

func AddMonster(num: int):
	for i in num:
		monsterSpawnNum += 1
		spawnPos.append(Vector2.ZERO)
		monsterToSpawn.append(0)

func riseSpawnRate():
	if  monsterSpawnTimerRange.x > 5 or monsterSpawnTimerRange.y > 10:
		monsterSpawnTimerRange -= Vector2(1, 1)

func _on_monster_spawn_timer_timeout() -> void:
	spawnMonster()
