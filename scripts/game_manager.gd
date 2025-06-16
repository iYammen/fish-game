extends Node2D
class_name  GameManager

const FOOD = preload("res://scenes/food.tscn")
var moneyLabel: Label
var stageGoalLabel: Label
var money: int = 100
var Fish: Array
var Food: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moneyLabel = get_tree().get_first_node_in_group("Money Label")
	stageGoalLabel = get_tree().get_first_node_in_group("Stage Goal Label")
	stageGoalLabel.text == str(400) + "$"
	moneyLabel.text = "Money: " + str(money) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Fish = get_tree().get_nodes_in_group("Fish")
	if Fish.size() == 0:
		get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	Food = get_tree().get_nodes_in_group("Food")
	if Food.size() < 3:
		if event.is_action_pressed("press") and money >= 5:
			var food = FOOD.instantiate()
			get_tree().root.add_child(food)
			food.position =  get_global_mouse_position()
			money -= 5
			moneyLabel.text = "Money: " + str(money) 

func addCoin(value: int):
	money += value
	moneyLabel.text = "Money: " + str(money) 
