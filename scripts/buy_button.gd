extends Button

var slot_machine: SlotMachine
var game_manager: GameManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot_machine = get_tree().get_first_node_in_group("Slot Machine")
	game_manager = get_tree().get_first_node_in_group("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	if game_manager.money >= 20:
		game_manager.subtractCoin(20)
		get_tree().paused = true
		slot_machine.show_machine()
