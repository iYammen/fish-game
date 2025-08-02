extends State
@export var fish: Guppy
var fishSpeed: float
var closestFood: Node2D
var food_scan_t := 0.0

func Enter() -> void:
	fishSpeed = randf_range(100,120)

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
			fish.global_position += direction * fishSpeed * delta
		else:
			fish.CoolDown_t = randf_range(0.5,0.7)
			state_transition.emit(self, "wander")
			return
		
		if distance < 20:
			if fish.is_hungry:
				if closestFood.is_in_group("Food"):
					if closestFood.eaten == false:
						AudioManager.playGulp()
						closestFood.eaten = true
						fish.is_hungry = false
						fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
						fish.hunger_t = fish.hungerWaitTime
						fish.feedCount += closestFood.foodQuality
						fish.checkFoodCount()
						fish._update_hunger_tint()
						closestFood.health.takeDamage(100)
						state_transition.emit(self, "wander")
		
		var flip_now := fish.global_position.x - closestFood.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now


func _update_closest_food() -> void:
	closestFood = null
	var allFood = EntityManager.allFood
	var foodSize: int = clampi(allFood.size(), 0, 45)
	var closest_dist := INF
	if allFood.is_empty():
		state_transition.emit(self, "wander")
		return
	for i in foodSize:
		var food = allFood[i]
		var dist = fish.global_position.distance_squared_to(food.global_position)
		if dist < closest_dist:
			closestFood = food
			closest_dist = dist

func Exit():
	pass
