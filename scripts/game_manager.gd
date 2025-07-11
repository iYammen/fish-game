extends Node2D
class_name  GameManager

const MOUSE_SHOOTING = preload("res://assets/mouse_shooting.png")
const MOUSE_POINTING = preload("res://assets/mouse_pointing.png")
const FOOD = preload("res://scenes/food.tscn")
const NUMBER_UI = preload("res://scenes/numberUI.tscn")
@onready var fps_label: Label = $"../CanvasLayer/fpsLabel"


@export var powerUps: Array[powerResource]

var powerUpBar: Control
var errorMessage: Panel
var moneyLabel: Label
var stageGoalLabel: Label
var powerScreen: powerUpScreen
var shop: Control
var stageButton: Button
var discount: float = 1
var boundray: Vector2 = Vector2(300, 144)
var goal: int = 10
var stage: int = 1
var money: int = 200
var Fish: Array

var FoodCountArray: Array
var allFood: Array
var foodMax: int = 3
var foodQuality: int = 1
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	Engine.time_scale = 1
	calculator.reset()
	Input.set_custom_mouse_cursor(MOUSE_POINTING, Input.CURSOR_POINTING_HAND, Vector2(32,16))
	Input.set_custom_mouse_cursor(MOUSE_SHOOTING, Input.CURSOR_CROSS, Vector2(32,32))
	shop = get_tree().get_first_node_in_group("Shop")
	moneyLabel = get_tree().get_first_node_in_group("Money Label")
	stageGoalLabel = get_tree().get_first_node_in_group("Stage Goal Label")
	powerScreen = get_tree().get_first_node_in_group("Power Screen")
	powerUpBar = get_tree().get_first_node_in_group("Power Up Bar")
	stageGoalLabel.text = "Stage " + str(stage)
	moneyLabel.text = "$: " + str(money)
	stageButton = get_tree().get_first_node_in_group("Stage Button")
	stageButton.text = "Next Stage: " + str(goal) + "$"
	errorMessage =  get_tree().get_first_node_in_group("Error Message")
	BloodManager.Reset()


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
			get_tree().reload_current_scene()

func editPowerUpBar(id: int):
	powerUpBar.powerUpIcons[id].addCount()

func _unhandled_input(event: InputEvent) -> void:
	FoodCountArray = get_tree().get_nodes_in_group("Player Food")
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("press"):
		if money >= 5:
			var inBourders: bool = get_global_mouse_position().x > -183 and get_global_mouse_position().x < 310 and get_global_mouse_position().y > -170 and get_global_mouse_position().y < 170
			if inBourders:
				if FoodCountArray.size() < foodMax:
					var food = FOOD.instantiate()
					get_tree().current_scene.add_child(food)
					food.position =  get_global_mouse_position()
					subtractCoin(5)

func addCoin(value: int):
	money += value
	moneyLabel.text = "$: " + str(money) 
	#checkScore()

func subtractCoin(value: int):
	money -= value
	moneyLabel.text = "$: " + str(money) 

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
	if money >= goal:
		subtractCoin(goal)
		goal = goal * 2
		stage += 1
		stageGoalLabel.text = "Stage " + str(stage)
		stageButton.text = "Next Stage: " + str(goal) + "$"
		powerScreen.setUpPowers()
		powerScreen.visible = true
		get_tree().paused = true
	else:
		errorMessage.visible = true
		await get_tree().create_timer(2).timeout
		errorMessage.visible = false

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-170, boundray.x), randf_range(-boundray.y, boundray.y))
	return targetPos


func _on_button_pressed() -> void:
	shop.showShop()


func _on_stage_button_pressed() -> void:
	checkScore()


func _on_button_button_down() -> void:
	errorMessage.visible = false
