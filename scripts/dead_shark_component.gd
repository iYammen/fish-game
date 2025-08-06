extends Node

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")


func AddMult():
	game_manager.animatePowerIcon(6)
	calculator.multiplier += 1
	game_manager.updateMultLabel()
	game_manager.animateMultLabel()
