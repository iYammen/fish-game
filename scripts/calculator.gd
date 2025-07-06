extends Node
class_name Calc

var multiplier: float = 1
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func reset():
	multiplier = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func calculateScore(score: int):
	var finalScore = score * multiplier
	return finalScore
