extends Node2D
class_name  GameManager

const FOOD = preload("res://scenes/food.tscn")
var boundray: Vector2 = Vector2(300, 200)
var moneyLabel: Label
var stageGoalLabel: Label
var powerScreen: powerUpScreen
var shop: Control
var goal: int = 200
var stage: int = 1
var money: int = 200
var Fish: Array

var Food: Array
var foodMax: int = 3
var foodQuality: int = 1
var exitingScreen: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	shop = get_tree().get_first_node_in_group("Shop")
	moneyLabel = get_tree().get_first_node_in_group("Money Label")
	stageGoalLabel = get_tree().get_first_node_in_group("Stage Goal Label")
	powerScreen = get_tree().get_first_node_in_group("Power Screen")
	stageGoalLabel.text = "Stage " + str(stage) + ": " + str(goal) + "$"
	moneyLabel.text = "$: " + str(money)
	call_deferred("checkScore")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Fish = get_tree().get_nodes_in_group("Fish")
	if Fish.size() == 0:
		get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	Food = get_tree().get_nodes_in_group("Player Food")
	if event.is_action_pressed("press"):
		if !exitingScreen and money >= 5:
			var inBourders: bool = get_global_mouse_position().x > -183 and get_global_mouse_position().x < 310 and get_global_mouse_position().y > -170 and get_global_mouse_position().y < 170
			if inBourders:
				if Food.size() < foodMax:
					var food = FOOD.instantiate()
					get_tree().current_scene.add_child(food)
					food.position =  get_global_mouse_position()
					subtractCoin(5)
		exitingScreen = false

func addCoin(value: int):
	money += value
	moneyLabel.text = "$: " + str(money) 
	checkScore()

func subtractCoin(value: int):
	money -= value
	moneyLabel.text = "$: " + str(money) 

func checkScore():
	if money >= goal:
		goal = goal * 2
		stage += 1
		stageGoalLabel.text = "Stage " + str(stage) + ": " + str(goal) + "$"
		powerScreen.setUpPowers()
		powerScreen.visible = true
		get_tree().paused = true

func GetDirection():
	var targetPos: Vector2 = Vector2(randf_range(-170, boundray.x), randf_range(-boundray.y, boundray.y))
	return targetPos


func _on_button_pressed() -> void:
	shop.showShop()
