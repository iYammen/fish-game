extends Button

@export var value: int = 20
var game_manager: GameManager
var hitFloor: bool = false
var collected: bool = false
var available: bool = false
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var disappear_t: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	disappear_t = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hitFloor:
		global_position.y += 50 * delta
		
	else:
		disappear_t -= delta
		modulate.a -= 1 / disappear_t * delta
	if ray_cast_2d.is_colliding() and !hitFloor:
		var collidedWith = ray_cast_2d.get_collider()
		if collidedWith.is_in_group("Ground Boundary"):
			hitFloor = true
			global_position.y = 144.0
			ray_cast_2d.enabled = false
	if disappear_t <= 0 and available == false:
		available = true
		global_position = Vector2(1000,1000)
		remove_from_group("Coin")
		process_mode = Node.PROCESS_MODE_DISABLED



func _on_button_down() -> void:
	if !collected:
		AudioManager.playCollect()
		var finalValue: int = calculator.calculateScore(value)
		collected = true
		game_manager.addCoin(finalValue)
		reuseManager.createNumbLabel(global_position, finalValue)
		
		available = true
		global_position = Vector2(1000,1000)
		remove_from_group("Coin")
		process_mode = Node.PROCESS_MODE_DISABLED

func resetCoin():
	process_mode = Node.PROCESS_MODE_INHERIT
	ray_cast_2d.enabled = true
	disappear_t = 2
	hitFloor = false
	modulate.a = 1
	available = false
	collected = false
	add_to_group("Coin")
