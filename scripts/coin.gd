extends Button

@export var value: int = 20
var game_manager: GameManager
var hitFloor: bool = false
@onready var timer: Timer = $Timer
var collected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hitFloor:
		global_position.y += 50 * delta



func _on_button_down() -> void:
	if !collected:
		var finalValue: int = calculator.calculateScore(value)
		collected = true
		game_manager.addCoin(finalValue)
		game_manager.ShowNumb(finalValue, global_position)
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground Boundary"):
		hitFloor = true
		timer.start()


func _on_timer_timeout() -> void:
	queue_free()
