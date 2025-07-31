extends Node

var chosenFish
var game_manager: GameManager
var multAmount: int
const SHINY = preload("res://Material/shiny.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	var fish: Array = get_tree().get_nodes_in_group("Fish")
	var i = randi_range(0, fish.size() - 1)
	chosenFish = fish[i]
	chosenFish.material = SHINY
	print(chosenFish)
	multAmount = randi_range(1,10)
	calculator.multiplier += multAmount
	game_manager.updateMultLabel()


func isFishAlive():
	print(chosenFish)
	if chosenFish == null:
		calculator.multiplier -= multAmount
		game_manager.updateMultLabel()
		queue_free()
