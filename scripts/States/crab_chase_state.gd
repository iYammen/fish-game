extends State
@export var crab: Crab
var closestCoins: Array[Button]
var chaseCoin: Button
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
		coolDown_t = randf_range(0.3,0.7)
	
	if chaseCoin:
		crab.global_position.x = move_toward(crab.global_position.x, chaseCoin.global_position.x, randf_range(30, 50) * delta)




func Exit():
	pass
