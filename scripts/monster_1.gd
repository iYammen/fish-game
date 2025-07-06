extends Area2D

@export var value: int
@export var health: healthComponent
@onready var move_timer: Timer = $moveTimer
var game_manager: GameManager
var fish: RigidBody2D
var target: Vector2
var speed: float
var entered: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var eat_timer: Timer = $eatTimer
@onready var blood: AnimatedSprite2D = $blood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target =  game_manager.GetDirection()
	health.died.connect(die)
	blood.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if global_position.x - target.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	global_position = lerp(global_position, target, 0.25 * delta)
	if entered: 
		animated_sprite_2d.play("Eat")
	else:
		animated_sprite_2d.play("Idle")

func die():
	var finalValue: int = calculator.calculateScore(value)
	game_manager.addCoin(finalValue)
	game_manager.ShowNumb(finalValue, global_position + Vector2(0, -15))
	blood.visible = true
	blood.play("default")
	animated_sprite_2d.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _on_timer_timeout() -> void:
	if entered:
		fish.health.takeDamage(100)

func _on_move_timer_timeout() -> void:
	target = game_manager.GetDirection()
	move_timer.start(randf_range(3, 6))

func _on_button_pressed() -> void:
	health.takeDamage(game_manager.damage)
	game_manager.ShowDamageNumb(game_manager.damage, get_global_mouse_position())

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
