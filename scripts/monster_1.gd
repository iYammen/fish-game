extends Node2D

@export var value: int
@export var health: healthComponent
var game_manager: GameManager
var target: Vector2
var speed: float = 30
var entered: bool = false
var eat_t := 0.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: Button = $Button
var closestFood: Node2D
var maxDist: float = 40
var cooldown_t: float 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_t = randf_range(0.3, 0.7)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target =  game_manager.GetDirection()
	health.died.connect(die)
	EntityManager.allMonsters.append(self)
	call_deferred("buffHealth")

func buffHealth():
	health.currentHealth += 10 * game_manager.stage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#movement
	var to_target = target - global_position
	var direction = to_target.normalized()
	var distance = to_target.length()
	
	if distance > speed * delta:
		global_position += direction * speed * delta
	else:
		target = game_manager.GetDirection()
	
	var flip_now := global_position.x < target.x
	if flip_now != animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = flip_now
	
	if closestFood:
		var to_fish_target = closestFood.global_position - global_position
		var distanceToFish = to_fish_target.length()
		
		if distanceToFish < maxDist and entered == false:
			entered = true
			AudioManager.playWhaleSound()
			eat_t = 0.5
		if distanceToFish >= maxDist:
			entered = false
			closestFood = null
		
		if entered:
			eat_t -= delta
			if eat_t <= 0.0:
				AudioManager.playFishEaten()
				closestFood.health.takeDamage(100)
				eat_t = 1.0
				game_manager.camera.screenShake(1, 0.2)
	else:
		if entered == true:
			entered = false
	cooldown_t -= delta
	if cooldown_t <= 0:
		_update_closest_food()
		cooldown_t = randf_range(0.3, 0.7)
	
	#animation
	var target_anim := "Eat" if entered else "Idle"
	if animated_sprite_2d.animation != target_anim:
		animated_sprite_2d.play(target_anim)

func die():
	EntityManager.allMonsters.erase(self)
	game_manager.checkEnemyCount()
	AudioManager.playBlood()
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	var finalValue: int = calculator.calculateScore(value)
	game_manager.addCoin(finalValue)
	reuseManager.createNumbLabel(global_position, finalValue)
	reuseManager.createMonsterBlood(global_position)
	animated_sprite_2d.visible = false
	queue_free()

func _on_button_pressed() -> void:
	AudioManager.playAttack()
	health.takeDamage(game_manager.damage)
	game_manager.ShowDamageNumb(game_manager.damage, get_global_mouse_position())
	game_manager.camera.screenShake(1, 0.1)


func _update_closest_food() -> void:
	var allFood = get_tree().get_nodes_in_group("Fish")
	var foodSize: int = clampi(allFood.size(), 0, 50)
	var closest_dist := INF

	if allFood.is_empty():
		return
	for i in foodSize:
		var food = allFood[i]
		var to_fish_target = global_position - food.global_position
		var dist = to_fish_target.length()
		if dist < closest_dist and dist < maxDist:
			closestFood = food
			closest_dist = dist


#func _on_area_exited(area: Area2D) -> void:
	#if area == fish:
		#entered = false
		#fish = null
