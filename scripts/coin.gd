extends Button

@export var value: int = 20
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += 50 * delta


func _on_button_down() -> void:
	game_manager.addCoin(value)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	queue_free()
