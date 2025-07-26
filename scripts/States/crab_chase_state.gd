extends State
@export var crab: Crab
var closestCoin: Button
var coolDown_t: float
var target: Vector2

func Enter() -> void:
	coolDown_t = randf_range(0.3,0.7)

func Update(_delta:float):
	if crab.global_position.x - target.x < 0:
		crab.sprite_2d.flip_h = true
	else:
		crab.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	
	coolDown_t -= delta
	if coolDown_t <=0:
		_update_closest_coin()
		coolDown_t = randf_range(0.3,0.7)
	
	if closestCoin:
		target = closestCoin.global_position
		crab.global_position.x = move_toward(crab.global_position.x, target.x, randf_range(30, 50) * delta)

func _update_closest_coin() -> void:
	closestCoin = null
	var allCoins = EntityManager.allCoins
	var coinSize: int = clampi(allCoins.size(), 0, 10)
	var closest_dist := INF
	
	for i in coinSize:
		var coin = allCoins[i]
		if coin != null:
			var dist = crab.global_position.distance_squared_to(coin.global_position)
			if dist < closest_dist:
				closestCoin = coin
				closest_dist = dist
	if closestCoin == null:
		state_transition.emit(self, "wander")

func Exit():
	pass


func _on_crab_area_entered(area: Area2D) -> void:
	if area != null:
		area.owner._on_button_down()
		state_transition.emit(self, "wander")
