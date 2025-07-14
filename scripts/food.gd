extends Area2D
class_name Food

@export var health: healthComponent
@export var foodQuality: int
var game_manager: GameManager
@onready var sprite_2d: Sprite2D = $Sprite2D
var hitFloor: bool = false
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	foodQuality = game_manager.foodQuality
	health.died.connect(die)
	var flipped: int = randi_range(0,1)
	if flipped:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

func die():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hitFloor:
		position.y += 50 * delta
	else:
		modulate.a -= 1 / timer.wait_time * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground Boundary"):
		hitFloor = true
		timer.start()

func _on_timer_timeout() -> void:
	die()
