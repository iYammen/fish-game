extends State
@export var fish: Node2D
@export var speed: float
var closestFood: Node2D
var food_scan_t := 0.0
var lastScanDist: Vector2
func Enter() -> void:
	food_scan_t = randf_range(0.1, 0.5)

func Physics_Update(delta: float):
	food_scan_t -= delta
	if food_scan_t <= 0.0:
		_update_closest_food()
		food_scan_t = randf_range(0.1, 0.5)
	if closestFood:
		var to_target = closestFood.global_position - fish.global_position
		var direction = to_target.normalized()
		var distance = to_target.length()
		
		if distance > fish.speed * delta:
			fish.global_position += direction * speed * delta
		else:
			fish.CoolDown_t = randf_range(0.5,0.7)
			state_transition.emit(self, "wander")
			return
		
		if distance < 30:
			if fish.is_hungry:
				if closestFood.is_in_group("Guppy") and closestFood.dead == false:
					if closestFood.grown_state == 0:
						closestFood.dead = true
						AudioManager.playFishEaten()
						fish.is_hungry = false
						fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
						fish.hunger_t = fish.hungerWaitTime
						closestFood.health.takeDamage(100)
						state_transition.emit(self, "wander")
		
		var flip_now := fish.global_position.x - closestFood.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now


func _update_closest_food() -> void:
	closestFood = null
	var allFood = EntityManager.allBabyGuppies
	var foodSize: int = clampi(allFood.size(), 0, 45)
	var closest_dist := INF
	
	for i in foodSize:
		var food = allFood[i]
		var dist = fish.global_position.distance_squared_to(food.global_position)
		if dist < closest_dist:
			closestFood = food
			closest_dist = dist
	if closestFood == null:
		state_transition.emit(self, "wander")

func Exit():
	pass
