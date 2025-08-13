extends Button

@export var value: int = 20
var game_manager: GameManager
var hitFloor: bool = false
var collected: bool = false
var available: bool = false
var disappear_t: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	disappear_t = 2
	EntityManager.allCoins.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !(global_position.y > 143):
		global_position.y += 50 * delta
	else:
		global_position.y = clampf(global_position.y ,0, 144)
		disappear_t -= delta
		modulate.a -= (0.5 / disappear_t )* delta
	if disappear_t <= 0 and available == false:
		global_position = Vector2(1000,1000)
		remove_from_group("Coin")
		EntityManager.allCoins.erase(self)
		available = true
		set_process(false)



func _on_button_down() -> void:
	if !collected:
		AudioManager.playCollect()
		var finalValue: int = calculator.calculateScore(value)
		collected = true
		game_manager.addCoin(finalValue)
		reuseManager.createNumbLabel(global_position, finalValue)
		global_position = Vector2(1000,1000)
		remove_from_group("Coin")
		EntityManager.allCoins.erase(self)
		available = true
		set_process(false)

func resetCoin():
	EntityManager.allCoins.append(self)
	set_process(true)
	disappear_t = 2
	hitFloor = false
	modulate.a = 1
	available = false
	collected = false
	add_to_group("Coin")
