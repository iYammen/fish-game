extends State

var guppy_manger: guppyManager
@export var crab: Crab

@export var speed: float = 0.5
var dir: int = 1
var closestCoin: Button
@onready var move_timer: Timer = $"../../moveTimer"
@onready var right_wall_check: RayCast2D = $"../../rightWallCheck"
@onready var left_wall_check: RayCast2D = $"../../leftWallCheck"


func Enter() -> void:
	move_timer.start(randf_range(2,8))

func Update(_delta: float):
	if dir == -1:
		crab.sprite_2d.flip_h = true
	else:
		crab.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	if right_wall_check.is_colliding():
		dir = -1
	elif left_wall_check.is_colliding():
		dir = 1
	crab.position.x += (50 * dir) * delta
	CheckCoin()

func CheckCoin():
	if closestCoin != null:
		state_transition.emit(self, "chase")
	else:
		var Coins = get_tree().get_nodes_in_group("Coin")
		for coin in Coins:
			if closestCoin == null:
				closestCoin = coin
			elif (crab.global_position - coin.global_position) < closestCoin.global_position:
				closestCoin = coin

func Exit():
	pass



func _on_move_timer_timeout() -> void:
	print(dir)
	dir = -dir
	move_timer.start(randf_range(2,8))
