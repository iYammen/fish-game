extends State
@export var fish: Guppy
@onready var move_timer: Timer = $"../../MoveTimer"
@onready var hunger_timer: Timer = $"../../hungerTimer"

var closestFood: Area2D
var target: Vector2

func Enter() -> void:
	move_timer.stop()

func Update(_delta:float):
	if fish.global_position.x - target.x < 0:
		fish.sprite_2d.flip_h = true
	else:
		fish.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	_update_closest_food()
	move_timer.stop()
	
	if closestFood:
		target = closestFood.global_position
		fish.global_position = fish.global_position.move_toward(target, 150 * delta)

func _update_closest_food() -> void:
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
	if hunger_timer.time_left < hunger_timer.wait_time / 1.5:
		hunger_timer.start(randf_range(15,40))
		fish.feedCount += 1
		area.queue_free()
		state_transition.emit(self, "wander")
