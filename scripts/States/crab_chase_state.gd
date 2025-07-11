extends State
@export var crab: Crab


var closestCoin: Button
var target: Vector2

func Enter() -> void:
	pass

func Update(_delta:float):
	if crab.global_position.x - target.x < 0:
		crab.sprite_2d.flip_h = true
	else:
		crab.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	_update_closest_coin()
	
	if closestCoin:
		target = closestCoin.global_position
		crab.global_position.x = move_toward(crab.global_position.x, target.x, randf_range(30, 50) * delta)

func _update_closest_coin() -> void:
	var coins = get_tree().get_nodes_in_group("Coin")
	for coin in coins:
		if closestCoin == null:
					closestCoin = coin
		elif crab.global_position.distance_to(coin.global_position) < crab.global_position.distance_to(closestCoin.global_position):
			closestCoin = coin
	if closestCoin == null:
		state_transition.emit(self, "wander")

func Exit():
	pass


func _on_crab_area_entered(area: Area2D) -> void:
	if area != null:
		area.owner._on_button_down()
		state_transition.emit(self, "wander")
