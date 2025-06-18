extends Button

@export var value: int = 20
var game_manager: GameManager
var hitFloor: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hitFloor:
		position.y += 50 * delta


func _on_button_down() -> void:
	game_manager.addCoin(value)
	queue_free()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	hitFloor = true
	await get_tree().create_timer(1).timeout
	free()
