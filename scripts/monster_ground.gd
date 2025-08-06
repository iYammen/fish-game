extends  Node2D

@export var health: healthComponent
@export var speed: float = 50.0
@export var value: int

var dir := 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var move_t: float
var coolDown_t: float

@onready var button: Button = $Button
var game_manager: GameManager

var fish: Node
var entered: bool = false
var eat_t := 0.0
var target_anim: String

var closestFood: Node2D
var maxDist: float = 60
var cooldown_t: float 

func _ready() -> void:
	cooldown_t = randf_range(0.3, 0.7)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	dir = -1 if randf() < 0.5 else 1
	move_t = randf_range(2.0, 8.0)
	coolDown_t = randf_range(0.3,0.7)
	health.died.connect(die)
	EntityManager.allMonsters.append(self)
	call_deferred("buffHealth")

func buffHealth():
	health.currentHealth += 10 * game_manager.stage

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
	
	var deadEnemyComponents :=  get_tree().get_nodes_in_group("Dead Enemy Component")
	if deadEnemyComponents.is_empty() != true:
		for component in deadEnemyComponents:
			component.AddMult()
		
	queue_free()

func _process(_delta: float) -> void:
	animated_sprite_2d.flip_h = dir == 1

func _physics_process(delta: float) -> void:
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
				target_anim = "chomp"
				AudioManager.playFishEaten()
				closestFood.health.takeDamage(100)
				eat_t = 1.0
				game_manager.camera.screenShake(1, 0.2)
			else:
				target_anim = "idle"
	else:
		if entered == true:
			entered = false
		target_anim = "run"
		# Wall collision check
		if global_position.x < -185:
			dir = 1
		elif global_position.x > 300:
			dir = -1
		
		# Movement
		position.x += speed * dir * delta
		
		move_t -= delta
		if move_t <=0:
			dir = -dir
			move_t = randf_range(2.0, 8.0)
	
	cooldown_t -= delta
	if cooldown_t <= 0:
		_update_closest_food()
		cooldown_t = randf_range(0.3, 0.7)
	
	
	if animated_sprite_2d.animation != target_anim:
		if animated_sprite_2d.animation == "chomp" and !animated_sprite_2d.is_playing():
			animated_sprite_2d.play(target_anim)
		elif animated_sprite_2d.animation != "chomp":
			animated_sprite_2d.play(target_anim)


func _on_body_entered(body: Node2D) -> void:
	if not entered:
		fish = body
		entered = true
		eat_t = 0.5

func _on_body_exited(body: Node2D) -> void:
	if body == fish:
		entered = false
		fish = null


func _on_button_button_down() -> void:
	AudioManager.playAttack()
	health.takeDamage(game_manager.damage)
	game_manager.ShowDamageNumb(game_manager.damage, get_global_mouse_position())
	game_manager.camera.screenShake(1, 0.1)
	AnimationManager.shakeAnim(animated_sprite_2d)
	var to_target = get_global_mouse_position().x - global_position.x
	var direction = clampi(to_target, -1, 1)
	if direction != 0:
		dir = -direction
		move_t = randf_range(2.0, 8.0)


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
