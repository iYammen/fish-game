extends State
@export var fish: Guppy

var closestFood: Area2D
var target: Vector2

func Enter() -> void:
	pass

func Physics_Update(_delta: float):
	_update_closest_food()
	if closestFood:
		var direction = (closestFood.global_position - fish.global_position).normalized()
		fish.sprite_2d.flip_h = direction.x > 0
		fish.linear_velocity = direction * 110


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
	pass

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Food"):
		if fish.is_hungry:
			fish.is_hungry = false
			fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
			fish.hunger_t = fish.hungerWaitTime
			fish.feedCount += area.foodQuality
			fish.checkFoodCount()
			area.health.takeDamage(100)
			state_transition.emit(self, "wander")
			print("hungry")
