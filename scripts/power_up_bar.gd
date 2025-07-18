extends Control

@export var powerUpIcons: Array[powerUpIcon]
var game_manager: GameManager 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#game_manager = get_tree().get_first_node_in_group("Game Manager")
	#for i in powerUpIcons.size():
		#powerUpIcons[i].tooltip_text = game_manager.powerUps[i].description
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
