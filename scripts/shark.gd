extends RigidBody2D

@onready var sprite_2d: Sprite2D = $sprite2D
@export var health: healthComponent
var damage: int = 20
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.died.connect(die)
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func die():
	reuseManager.createBlood(global_position)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
