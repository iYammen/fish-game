extends Area2D

@export var health: healthComponent
@onready var move_timer: Timer = $moveTimer
var game_manager: GameManager
var fish: RigidBody2D
var target: Vector2
var speed: float
var entered: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var eat_timer: Timer = $eatTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target =  game_manager.GetDirection()
	health.died.connect(die)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, target, 0.25 * delta)
	if entered: 
		animated_sprite_2d.play("Eat")
	else:
		animated_sprite_2d.play("Idle")

func die():
	queue_free()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_timer_timeout() -> void:
	if entered:
		fish.health.takeDamage(100)

func _on_move_timer_timeout() -> void:
	target = game_manager.GetDirection()
	move_timer.start(randf_range(3, 6))

func _on_button_pressed() -> void:
	health.takeDamage(10)

func _on_body_entered(body: Node2D) -> void:
	if eat_timer.is_stopped():
		eat_timer.start()
		entered = true
		fish = body

func _on_body_exited(body: Node2D) -> void:
	if body == fish:
		eat_timer.stop()
		entered = false
		fish = null
