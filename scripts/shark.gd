extends Node2D

@onready var sprite_2d: Sprite2D = $sprite2D
@export var health: healthComponent
@export var damage: int = 20
var game_manager: GameManager
@export var speed: float
var attackCoolDown_t: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.died.connect(die)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	game_manager.addToFishCount()

func _physics_process(delta: float) -> void:
	attackCoolDown_t -= delta

func die():
	game_manager.removeFromFishCount()
	AudioManager.playBlood()
	reuseManager.createBlood(global_position)
	var DeadSharkComponents :=  get_tree().get_nodes_in_group("Dead Shark Component")
	if DeadSharkComponents.is_empty() != true:
		for component in DeadSharkComponents:
			component.AddMult()
	if get_tree().get_nodes_in_group("Fish Dead Component").is_empty() != true:
		var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
		for component in fishDeadComponents:
			component.AddMult()
	queue_free()
