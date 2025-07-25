extends Node2D
class_name  GameManager

const MOUSE_POINTING = preload("res://assets/UI/mouse_pointing.png")
const MOUSE_SHOOTING = preload("res://assets/UI/mouse_shooting.png")
const FOOD = preload("res://scenes/food.tscn")
const NUMBER_UI = preload("res://scenes/numberUI.tscn")
@onready var fps_label: Label = $"../CanvasLayer/fpsLabel"


@export var powerUps: Array[powerResource]
@export var basicPowerUps: Array[powerResource]

var powerUpBar: Control
var errorMessage: Panel
var moneyLabel: Label
var stageGoalLabel: Label
var powerScreen: powerUpScreen
var shop: Control
var stageButton: Button
var spawn_manager: spawnManager
var game_over_Screen: Control

var discount: float = 1
var boundray: Vector2 = Vector2(300, 128)
var money: int = 200000000000
var goal: int = 400
var stage: int = 1
var Fish: Array

var FoodCountArray: Array
var allFood: Array
var foodMax: int = 1
var foodQuality: int = 1
var damage: int = 10
var dead: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_use_accumulated_input(false)
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Engine.time_scale = 1
	AudioManager.playSplash()
	get_tree().paused = false
	calculator.reset()
	Input.set_custom_mouse_cursor(MOUSE_POINTING, Input.CURSOR_POINTING_HAND, Vector2(32,16))
	Input.set_custom_mouse_cursor(MOUSE_SHOOTING, Input.CURSOR_CROSS, Vector2(32,32))
	shop = get_tree().get_first_node_in_group("Shop")
	moneyLabel = get_tree().get_first_node_in_group("Money Label")
	stageGoalLabel = get_tree().get_first_node_in_group("Stage Goal Label")
	powerScreen = get_tree().get_first_node_in_group("Power Screen")
	powerUpBar = get_tree().get_first_node_in_group("Power Up Bar")
	stageGoalLabel.text = "Stage " + str(stage)
	moneyLabel.text = "$: " + abriviateNum(money)
	stageButton = get_tree().get_first_node_in_group("Stage Button")
	spawn_manager = get_tree().get_first_node_in_group("Spawn Manager")
	stageButton.text = "Next Stage: " + abriviateNum(goal) + "$"
	errorMessage =  get_tree().get_first_node_in_group("Error Message")
	game_over_Screen = get_tree().get_first_node_in_group("Game Over Screen")
	reuseManager.Reset()
	EntityManager.Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.text = "fps: " + str(Engine.get_frames_per_second())


func checkFishAmount():
	if is_inside_tree():
		if get_tree().get_nodes_in_group("Guppy").is_empty() != true:
			Fish = get_tree().get_nodes_in_group("Guppy")
		else:
			Fish.resize(0)
		if Fish.size() == 0:
			dead = true
			await get_tree().create_timer(1).timeout
			game_over_Screen.gameOver(stage)

func editPowerUpBar(id: int):
	powerUpBar.powerUpIcons[id].addCount()

func _unhandled_input(event: InputEvent) -> void:
	# Filter out mouse movement or irrelevant input
	if not (event is InputEventMouseButton or event is InputEventKey):
		return
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if dead and event.is_action_pressed("gameOver"):
		AudioManager.playButtonClick()
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("press"):
		if money >= 5:
			FoodCountArray = get_tree().get_nodes_in_group("Player Food")
			var mouse_pos = get_global_mouse_position()
			var in_bounds = mouse_pos.x > -200 and mouse_pos.x < 315 and mouse_pos.y > -170 and mouse_pos.y < 170
			if in_bounds:
				if FoodCountArray.size() < foodMax:
					AudioManager.playPop()
					var food = FOOD.instantiate()
					get_tree().current_scene.add_child(food)
					food.position =  get_global_mouse_position()
					subtractCoin(5)

func addCoin(value: int):
	if value < 0:
		return
	money += value
	moneyLabel.text = "$: " + abriviateNum(money)
	#checkScore()

func subtractCoin(value: int):
	if value < 0:
		return
	money -= value
	moneyLabel.text = "$: " + abriviateNum(money)

func ShowNumb(numbValue: int, currentPos: Vector2):
	var number = NUMBER_UI.instantiate()
	get_tree().current_scene.add_child(number)
	number.setNumber(numbValue)
	number.global_position = currentPos

func ShowDamageNumb(numbValue: int, currentPos: Vector2):
	var number = NUMBER_UI.instantiate()
	get_tree().current_scene.add_child(number)
	number.setDamageNumber(numbValue)
	number.global_position = currentPos

func ShowText(words: String, currentPos: Vector2, color: Color):
	var number = NUMBER_UI.instantiate()
	get_tree().current_scene.add_child(number)
	number.modulate = color
	number.setText(words)
	number.global_position = currentPos

func checkScore():
	if checkMoney(money, goal):
		spawn_manager.riseSpawnRate()
		subtractCoin(goal)
		AudioManager.playNextStage()
		stage += 1
		if stage % 3 == 0:
			goal = goal * 1.7
			powerScreen.setUpPowers()
			powerScreen.visible = true
			get_tree().paused = true
		else:
			goal = goal * 1.5
			powerScreen.setUpBasicPowers()
			powerScreen.visible = true
			get_tree().paused = true
		if stage % 5 == 0:
			spawn_manager.monsterSpawnNum += 1
			spawn_manager.spawnPos.append(Vector2.ZERO)
			spawn_manager.monsterToSpawn.append(0)
		stageGoalLabel.text = "Stage " + str(stage)
		stageButton.text = "Next Stage: " + abriviateNum(goal) + "$"
	else:
		AudioManager.playError()
		errorMessage.visible = true
		await get_tree().create_timer(2).timeout
		errorMessage.visible = false

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-200, boundray.x), randf_range(-100, boundray.y))
	return targetPos

func abriviateNum(num: int):
	var newNum: String
	if num < 1000:
		newNum = str(num)
		return newNum
	elif num < 1000000:
		var dividedNum: float
		dividedNum = float(num) / 1000
		newNum = ("%.2f" % dividedNum) + "K"
		return newNum
	elif num < 1000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000
		newNum = ("%.2f" % dividedNum) + "M"
		return newNum
	elif num < 1000000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000000
		newNum = ("%.2f" % dividedNum) + "B"
		return newNum
	elif num < 1000000000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000000000
		newNum = ("%.2f" % dividedNum) + "T"
		return newNum

func checkMoney(num: int, moneyGoal: int):
	var newNum: float
	var newGoalNum: float
	var enoughMoney: bool
	if num < moneyGoal:
		newNum = float(abriviateNum(num))
		newGoalNum = float(abriviateNum(moneyGoal))
		if num < 1000:
			enoughMoney = false
			return enoughMoney
		elif num < 1000000:
			if moneyGoal < 1000000:
				goal = int(newGoalNum * 1000)
				money = int(newNum * 1000)
				if newNum >= newGoalNum:
					enoughMoney = true
				else:
					enoughMoney = false
				return enoughMoney
			else:
				enoughMoney = false
				return enoughMoney
		elif num < 1000000000:
			if moneyGoal < 1000000000:
				goal = int(newGoalNum * 1000000)
				money = int(newNum * 1000000)
				if newNum >= newGoalNum:
					enoughMoney = true
				else:
					enoughMoney = false
				return enoughMoney
			else:
				enoughMoney = false
				return enoughMoney
		elif num < 1000000000000:
			if moneyGoal < 1000000000000:
				goal = int(newGoalNum * 1000000000)
				money = int(newNum * 1000000000)
				if newNum >= newGoalNum:
					enoughMoney = true
				else:
					enoughMoney = false
				return enoughMoney
			else:
				enoughMoney = false
				return enoughMoney
		elif num < 1000000000000000:
			if moneyGoal < 1000000000000000:
				goal = int(newGoalNum * 1000000000000)
				money = int(newNum * 1000000000000)
				if newNum >= newGoalNum:
					enoughMoney = true
				else:
					enoughMoney = false
				return enoughMoney
			else:
				enoughMoney = false
				return enoughMoney
	else:
		enoughMoney = true
		return enoughMoney

#UI buttons
func _on_button_pressed() -> void:
	shop.showShop()
	AudioManager.playButtonClick()

func _on_stage_button_pressed() -> void:
	AudioManager.playButtonClick()
	if !dead:
		checkScore()

func _on_button_button_down() -> void:
	AudioManager.playButtonClick()
	errorMessage.visible = false


func _on_music_mute_button_down() -> void:
	AudioManager.playButtonClick()
	AudioManager.muteMusic()

func _on_sound_mute_button_down() -> void:
	AudioManager.playButtonClick()
	AudioManager.muteSoundEffects()


func _on_full_screen_button_down() -> void:
	AudioManager.playButtonClick()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)


func _on_quit_button_down() -> void:
	get_tree().quit()
