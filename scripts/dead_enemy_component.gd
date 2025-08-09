extends Node

var game_manager: GameManager
@export var value: int 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func AddMult():
	game_manager.animateMultLabel()
	game_manager.animatePowerIcon(10)
	calculator.multiplier += value
	game_manager.updateMultLabel()
	await get_tree().create_timer(2).timeout
	game_manager.animateMultLabel()
	calculator.multiplier -= value
	game_manager.updateMultLabel()
