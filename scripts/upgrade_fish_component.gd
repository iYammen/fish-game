extends Node

var chosenFish
var game_manager: GameManager
var multAmount: int
const SHINY = preload("res://Material/shiny.tres")
var removed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	var fish: Array = get_tree().get_nodes_in_group("Fish")
	if !fish.is_empty():
		var i = randi_range(0, fish.size() - 1)
		chosenFish = fish[i]
		chosenFish.material = SHINY
		multAmount = randi_range(1,3)
		calculator.multiplier += multAmount
		game_manager.animatePowerIcon(9)
		game_manager.updateMultLabel()
		game_manager.animateMultLabel()


func isFishAlive():
	if chosenFish == null and removed == false:
		removed = true
		game_manager.editPowerUpBar(9, false)
		calculator.multiplier -= multAmount
		game_manager.updateMultLabel()
		game_manager.animateMultLabel()
		queue_free()
