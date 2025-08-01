extends Area2D

@export var value: int
@export var health: healthComponent
var game_manager: GameManager
var fish: Area2D
var target: Vector2
var speed: float = 30
var entered: bool = false
var eat_t := 0.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target =  game_manager.GetDirection()
	health.died.connect(die)
	EntityManager.allMonsters.append(self)
	call_deferred("buffHealth")

func buffHealth():
	health.currentHealth += 10 * game_manager.stage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var to_target = target - global_position
	var direction = to_target.normalized()
	var distance = to_target.length()
	
	if distance > speed * delta:
		global_position += direction * speed * delta
	else:
		target = game_manager.GetDirection()
	
	if entered:
		eat_t -= delta
	
	if eat_t <= 0.0 and entered and fish:
		AudioManager.playFishEaten()
		fish.health.takeDamage(100)
		eat_t = 1.0
		game_manager.camera.screenShake(1, 0.2)
	
	var flip_now := global_position.x < target.x
	if flip_now != animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = flip_now
	
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


func _on_area_entered(area: Area2D) -> void:
	if fish == null:
		AudioManager.playWhaleSound()
		fish = area
		entered = true
		eat_t = 0.5


func _on_area_exited(area: Area2D) -> void:
	if area == fish:
		entered = false
		fish = null
