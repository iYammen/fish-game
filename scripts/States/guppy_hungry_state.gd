extends State
@export var fish: Guppy
@onready var move_timer: Timer = $"../../MoveTimer"
@onready var hunger_timer: Timer = $"../../hungerTimer"

var closestFood: Area2D
var target: Vector2

func Enter() -> void:
	move_timer.stop()

func Update(_delta:float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	_update_closest_food()
	move_timer.stop()
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
		if hunger_timer.time_left < hunger_timer.wait_time / 1.5:
			hunger_timer.start(randf_range(fish.hungerTimerRange.x,fish.hungerTimerRange.y))
			fish.feedCount += area.foodQuality
			fish.checkFoodCount()
			area.health.takeDamage(100)
			state_transition.emit(self, "wander")
