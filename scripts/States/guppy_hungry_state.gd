extends State
@export var fish: Guppy

var closestFood: Area2D

func Enter() -> void:
	pass

func Physics_Update(delta: float):
	_update_closest_food()
	if closestFood:
		var direction = (closestFood.global_position - fish.global_position).normalized()
		fish.global_position += direction * 110 * delta
		
		var flip_now := fish.global_position.x - closestFood.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now


func _update_closest_food() -> void:
	closestFood = null
	var foods = get_tree().get_nodes_in_group("Food")
	for food in foods:
		if closestFood == null:
					closestFood = food
		elif fish.global_position.distance_to(food.global_position) < fish.global_position.distance_to(closestFood.global_position):
			closestFood = food
	if closestFood == null:
		state_transition.emit(self, "wander")

func Exit():
	fish.tintCheck_t = 0

func _on_hit_box_area_entered(area: Area2D) -> void:
	if fish.is_hungry:
		if area.is_in_group("Food"):
			fish.is_hungry = false
			fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
			fish.hunger_t = fish.hungerWaitTime
			fish.feedCount += area.foodQuality
			fish.checkFoodCount()
			area.health.takeDamage(100)
			state_transition.emit(self, "wander")
