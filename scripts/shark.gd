extends RigidBody2D

@onready var sprite_2d: Sprite2D = $sprite2D
@export var health: healthComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.died.connect(die)

func die():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
