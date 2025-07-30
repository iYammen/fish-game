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
var money: int = 200000000
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
var scaleTween: Tween
var moneyScaleTween: Tween

var camera: Camera2D
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
	fishCountLabel = get_tree().get_first_node_in_group("Fish Count")
	multLabel = get_tree().get_first_node_in_group("Multiplier")
	camera = get_tree().get_first_node_in_group("Camera")
	guppyLeft = get_tree().get_first_node_in_group("Guppy Left")
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



func animatePowerIcon(id: int):
	powerUpBar.animateIcon(id)

func animateMoneyLabel():
	moneyLabel.pivot_offset = Vector2(moneyLabel.size.x / 2, moneyLabel.size.y / 2)
	if moneyScaleTween and moneyScaleTween.is_running():
		return
	
	moneyScaleTween = create_tween()
	# Scale up (quick ease out)
	moneyScaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	moneyScaleTween.tween_property(moneyLabel, "rotation_degrees", 6.6, 0.05)
	moneyScaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	moneyScaleTween.tween_property(moneyLabel, "rotation_degrees", -6.6, 0.05)
	# Then scale down (with bounce)
	moneyScaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	moneyScaleTween.tween_property(moneyLabel, "rotation_degrees", 0, 0.25)

func animateMultLabel():
	if scaleTween and scaleTween.is_running():
		return
	
	scaleTween = create_tween()
	# Scale up (quick ease out)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(multLabel, "rotation_degrees", 6.6, 0.05)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(multLabel, "rotation_degrees", -6.6, 0.05)
	# Then scale down (with bounce)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(multLabel, "rotation_degrees", 0, 0.25)

func addCoin(value: int):
	if value < 0:
		return
	animateMoneyLabel()
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

func updateMultLabel():
	multLabel.text = ("%.1f" % calculator.multiplier) + "X"


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
	var current_mode := DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED or current_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)


func _on_quit_button_down() -> void:
	get_tree().quit()
