extends State

var guppy_manger: guppyManager
@export var fish: Guppy

@export var speed: float = 0.5
var target: Vector2
var closestFood: Area2D
@onready var move_timer: Timer = $"../../MoveTimer"
@onready var hunger_timer: Timer = $"../../hungerTimer"

func Enter() -> void:
	move_timer.start()
	guppy_manger = get_tree().get_first_node_in_group("Guppy Manager")
	target = guppy_manger.GetDirection()

func Update(_delta: float):
	if fish.global_position.x - target.x < 0:
		fish.sprite_2d.flip_h = true
	else:
		fish.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	fish.linear_velocity.x = clamp(fish.linear_velocity.x, -50, 50)
	fish.linear_velocity.y = clamp(fish.linear_velocity.y, -50, 50)
	fish.linear_velocity =  lerp(fish.linear_velocity, target, speed * delta)
	CheckHunger()

func CheckHunger():
	if hunger_timer.time_left < hunger_timer.wait_time / 1.5:
		if closestFood != null:
			state_transition.emit(self, "hungry")
		else:
			var allFood = get_tree().get_nodes_in_group("Food")
			for food in allFood:
				if closestFood == null:
					closestFood = food
				elif (fish.global_position - food.global_position) < closestFood.global_position:
					closestFood = food

func Exit():
	pass


func _on_move_timer_timeout() -> void:
	target = guppy_manger.GetDirection()
	move_timer.start(randf_range(0.3, 4))


func _on_hit_box_body_entered(_body: Node2D) -> void:
	target = -fish.linear_velocity
	fish.linear_velocity = Vector2.ZERO
