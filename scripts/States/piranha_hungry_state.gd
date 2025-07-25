extends State
@export var fish: Guppy2
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
		var direction = (closestFood.global_position - fish.global_position).normalized()
		fish.global_position += direction * speed * delta
		
		var flip_now := fish.global_position.x - closestFood.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now


func _update_closest_food() -> void:
	closestFood = null
	var allFood = EntityManager.allGuppies
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

func _on_hit_box_area_entered(area: Area2D) -> void:
	if fish.is_hungry:
		if area.owner.is_in_group("Guppy"):
			if area.owner.feedCount < 4:
				AudioManager.playFishEaten()
				fish.is_hungry = false
				fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
				fish.hunger_t = fish.hungerWaitTime
				area.owner.health.takeDamage(100)
				state_transition.emit(self, "wander")
