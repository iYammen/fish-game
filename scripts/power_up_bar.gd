extends Control

@export var powerUpIcons: Array[powerUpIcon]
@export var powerUps: Array[powerResource]
var game_manager: GameManager 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in powerUpIcons.size():
		powerUpIcons[i].tooltip_text = powerUps[i].description
