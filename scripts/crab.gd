extends Node2D
class_name Crab
@onready var sprite_2d: Sprite2D = $sprite2D
@export var health: healthComponent
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.died.connect(die)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	game_manager.addToFishCount()


func die():
	game_manager.removeFromFishCount()
	AudioManager.playBlood()
	reuseManager.createBlood(global_position)
	sprite_2d.visible = false
	if get_tree().get_nodes_in_group("Fish Dead Component").is_empty() != true:
		var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
		for component in fishDeadComponents:
			component.AddMult()
	queue_free()
