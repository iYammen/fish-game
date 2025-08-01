extends Node

var added: bool = false
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	if game_manager.fishCount <= 600:
		calculator.multiplier += 25
		game_manager.animatePowerIcon(8)
		game_manager.animateMultLabel()
		game_manager.updateMultLabel()
		added = true

func _process(_delta: float) -> void:
	if !added and game_manager.fishCount <= 600:
		calculator.multiplier += 25
		game_manager.updateMultLabel()
		game_manager.animatePowerIcon(8)
		game_manager.animateMultLabel()
		added = true
	elif game_manager.fishCount > 600 and added:
		calculator.multiplier -= 25
		game_manager.updateMultLabel()
		game_manager.animatePowerIcon(8)
		game_manager.animateMultLabel()
		added = false
