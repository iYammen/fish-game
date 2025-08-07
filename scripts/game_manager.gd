extends Node2D
class_name  GameManager

const MOUSE_POINTING = preload("res://assets/UI/mouse_pointing.png")
const MOUSE_SHOOTING = preload("res://assets/UI/mouse_shooting.png")
const FOOD = preload("res://scenes/food.tscn")
const NUMBER_UI = preload("res://scenes/numberUI.tscn")
@onready var fps_label: Label = $"../CanvasLayer/fpsLabel"

@export var allPowerUps: Array[powerResource]
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
var money: int = 4000000
var goal: int = 400
var stage: int = 1
var Fish: Array

var FoodCountArray: Array
var allFood: Array
var foodMax: int = 1
var foodQuality: int = 1
var damage: int = 10
var dead: bool = false
var fishCountLabel: Label
var multLabel: Label
var fishCount: int = 0

var guppyLeft: Label

var camera: Camera2D
var settings: Control
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
	stageButton.text = "Next: " + abriviateNum(goal) + "$"
	errorMessage =  get_tree().get_first_node_in_group("Error Message")
	game_over_Screen = get_tree().get_first_node_in_group("Game Over Screen")
	fishCountLabel = get_tree().get_first_node_in_group("Fish Count")
	multLabel = get_tree().get_first_node_in_group("Multiplier")
	camera = get_tree().get_first_node_in_group("Camera")
	guppyLeft = get_tree().get_first_node_in_group("Guppy Left")
	settings = get_tree().get_first_node_in_group("Settings")
	reuseManager.Reset()
	EntityManager.Reset()
	AudioManager.DarkMusicToOceanMusic()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.text = "fps: " + str(Engine.get_frames_per_second())

func addToFishCount():
	fishCount += 1
	fishCountLabel.text = "Fish Count: " + str(fishCount)

func removeFromFishCount():
	fishCount -= 1
	fishCountLabel.text = "Fish Count: " + str(fishCount)
	call_deferred("_check_fish_upgrades")

func _check_fish_upgrades():
	if is_inside_tree():
		var upgrades: Array = get_tree().get_nodes_in_group("Upgrade Fish Component")
		if !upgrades.is_empty():
			for upgrade in upgrades:
				upgrade.isFishAlive()

func editPowerUpBar(id: int, add: bool):
	if add:
		powerUpBar.powerUpIcons[id].addCount()
	else:
		powerUpBar.powerUpIcons[id].removeCount()

func _unhandled_input(event: InputEvent) -> void:
	# Filter out mouse movement or irrelevant input
	if not (event is InputEventMouseButton or event is InputEventKey):
		return
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if dead and event.is_action_pressed("gameOver"):
		AudioManager.playButtonClick()
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("pause"):
		if settings.showing == false:
			settings.showSettings()
		else:
			settings.hideSettings()
	
	if event.is_action_pressed("press"):
		FoodCountArray = get_tree().get_nodes_in_group("Player Food")
		var mouse_pos = get_global_mouse_position()
		var in_bounds = mouse_pos.x > -200 and mouse_pos.x < 315 and mouse_pos.y > -170 and mouse_pos.y < 170
		if in_bounds:
			if FoodCountArray.size() < foodMax:
				AudioManager.playPop()
				var food = FOOD.instantiate()
				get_tree().current_scene.add_child(food)
				food.position =  get_global_mouse_position()

func animatePowerIcon(id: int):
	powerUpBar.animateIcon(id)

func animateMultLabel():
	AnimationManager.shakeAnim(multLabel)

func addCoin(value: int):
	if value < 0:
		return
	#animate
	moneyLabel.pivot_offset = Vector2(moneyLabel.size.x / 2, moneyLabel.size.y / 2)
	AnimationManager.shakeAnim(moneyLabel)
	
	money += value
	moneyLabel.text = "$: " + abriviateNum(money)

func subtractCoin(value: int):
	if value < 0:
		return
	money -= value
	moneyLabel.text = "$: " + abriviateNum(money)

func ShowDamageNumb(numbValue: int, currentPos: Vector2):
	var number = NUMBER_UI.instantiate()
	get_tree().current_scene.add_child(number)
	number.setDamageNumber(numbValue)
	number.global_position = currentPos

func checkFishAmount():
	if is_inside_tree():
		var allGuppies: Array = EntityManager.allGuppies
		if allGuppies.is_empty():
			dead = true
			await get_tree().create_timer(1).timeout
			game_over_Screen.gameOver(stage)
		else:
			guppyLeft.text = "Guppys Left: " + str(allGuppies.size())

func checkScore():
	if checkMoney(money, goal):
		spawn_manager.riseSpawnRate()
		subtractCoin(goal)
		AudioManager.playNextStage()
		stage += 1
		if stage % 3 == 0:
			goal = round(goal * 1.7)
			powerScreen.setUpPowers()
			powerScreen.showScreen()
		else:
			goal = round(goal * 1.5)
			powerScreen.setUpBasicPowers()
			powerScreen.showScreen()
		if stage % 5 == 0:
			spawn_manager.AddMonster(1)
		elif stage % 12 == 0:
			spawn_manager.AddMonster(1)

		stageGoalLabel.text = "Stage " + str(stage)
		stageButton.text = "Next: " + abriviateNum(goal) + "$"
	else:
		AudioManager.playError()
		errorMessage.visible = true
		await get_tree().create_timer(2).timeout
		errorMessage.visible = false

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

func checkEnemyCount():
	var allMonsters = EntityManager.allMonsters
	if allMonsters.is_empty() and spawn_manager.monster_spawn_timer.time_left > 5:
		AudioManager.DarkMusicToOceanMusic()

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-200, 300), randf_range(-128, 128))
	return targetPos

func abriviateNum(num: int):
	var newNum: String
	if num < 1000:
		newNum = str(num)
		return newNum
	elif num < 1000000:
		var dividedNum: float
		dividedNum = float(num) / 1000
		newNum = ("%.1f" % dividedNum) + "K"
		return newNum
	elif num < 1000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000
		newNum = ("%.1f" % dividedNum) + "M"
		return newNum
	elif num < 1000000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000000
		newNum = ("%.1f" % dividedNum) + "B"
		return newNum
	elif num < 1000000000000000:
		var dividedNum: float
		dividedNum = float(num) / 1000000000000
		newNum = ("%.1f" % dividedNum) + "T"
		return newNum

func updateMultLabel():
	multLabel.text = ("%.1f" % calculator.multiplier) + "X"


#UI buttons
func _on_button_pressed() -> void:
	AudioManager.playButtonClick()
	shop.showShop()


func _on_stage_button_pressed() -> void:
	AudioManager.playButtonClick()
	if !dead:
		checkScore()

func _on_button_button_down() -> void:
	AudioManager.playButtonClick()
	errorMessage.visible = false

func _on_settings_button_down() -> void:
	AudioManager.playButtonClick()
	settings.showSettings()
