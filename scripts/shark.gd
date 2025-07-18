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

func _physics_process(delta: float) -> void:
	attackCoolDown_t -= delta

func die():
	reuseManager.createBlood(global_position)
	queue_free()
