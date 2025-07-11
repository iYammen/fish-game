extends Node

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func AddMult():
	calculator.multiplier += 0.5
	await get_tree().create_timer(2).timeout
	calculator.multiplier -= 0.5
