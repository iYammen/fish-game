extends RigidBody2D

@export var speed: float = 20
@onready var timer: Timer = $Timer
var guppy_manger: guppyManager
var target: Vector2
@onready var sprite_2d: Sprite2D = $sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guppy_manger = get_tree().get_first_node_in_group("Guppy Manager")
	target = guppy_manger.GetDirection()


func _physics_process(delta: float) -> void:
	linear_velocity =  lerp(linear_velocity, target, speed * delta)
	if target.x > 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false


func _on_timer_timeout() -> void:
	target = guppy_manger.GetDirection()
	timer.start(randf_range(0.3, 4))

func _on_wall_detect_body_entered(body: Node2D) -> void:
	target = -linear_velocity
	linear_velocity = Vector2.ZERO
