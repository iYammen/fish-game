extends Node

var game_manager: GameManager
@export var value: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	var allGuppies: Array = EntityManager.allGuppies
	for guppy in allGuppies:
		if guppy.grown_state == 2:
			AddMult()


func AddMult():
	game_manager.animateMultLabel()
	game_manager.animatePowerIcon(7)
	calculator.multiplier += value
	game_manager.updateMultLabel()

func RemoveMult():
	game_manager.animateMultLabel()
	calculator.multiplier -= value
	game_manager.updateMultLabel()
