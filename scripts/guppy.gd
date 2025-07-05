extends RigidBody2D
class_name Guppy

@export var nameRes: nameResource
@export var hungerTimerRange: Vector2
@export var hungerAdultTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent
@onready var move_timer: Timer = $MoveTimer
@onready var hunger_timer: Timer = $hungerTimer
@onready var blood: AnimatedSprite2D = $blood
@onready var name_label: Label = $nameLabel

var feedCount: int = 0
var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
@onready var money_timer: Timer = $moneyTimer
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
@onready var state_machine: stateMachine = $state_machine
signal state_transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	state_transition.connect(state_machine.change_state)
	input_pickable = true
	name_label.visible = false
	set_random_name()
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	hunger_timer.start(randf_range(hungerTimerRange.x,hungerTimerRange.y))

func set_random_name() -> void:
	var parts: int = randi_range(1, 3)

	var names_copy: Array = nameRes.names.duplicate()
	names_copy.shuffle()
	var chosen: Array = names_copy.slice(0, parts)
	
	if chosen.size() >= 2 and randi_range(1, 3) == 1:  # 10 % roll
			# Check whether any article is already inside the chosen words
			var lower_chosen: Array = chosen.map(func(n): return String(n).to_lower())
			var article_found: bool = false
			for art in nameRes.articles:
				if lower_chosen.has(art.to_lower()):
					article_found = true
					break
			
			# Insert only if none were found
			if not article_found and nameRes.articles.size() > 0:
				var article: String = nameRes.articles[randi_range(0, nameRes.articles.size() - 1)]
				chosen.insert(chosen.size() - 1, article)  # before the last name

	name_label.text = " ".join(chosen)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		die()
	if hunger_timer.time_left > hunger_timer.wait_time / 2:
		sprite_2d.modulate = Color.WHITE
	else:
		sprite_2d.modulate = Color.LIME
		if hunger_timer.time_left < hunger_timer.wait_time / 3:
			sprite_2d.modulate = Color.DARK_GREEN

func _physics_process(_delta: float) -> void:
	pass

func checkFoodCount():
	if !makingMoney and feedCount >= 3:
		money_timer.start(randf_range(5, 10))
		makingMoney = true
	if feedCount >= 3 and feedCount < 6:
		sprite_2d.frame = 1
	elif feedCount >= 6:
		sprite_2d.frame = 2
		hungerTimerRange = hungerAdultTimerRange

func die():
	blood.play("default")
	sprite_2d.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _on_hunger_timer_timeout() -> void:
	die()


func _on_mouse_entered() -> void:
	name_label.visible = true

func _on_mouse_exited() -> void:
	name_label.visible = false

func _on_money_timer_timeout() -> void:
	if feedCount >= 3 and feedCount < 6:
		var coin: Button = BRONZE_COIN.instantiate()
		get_tree().root.add_child(coin)
		coin.global_position = global_position
	elif feedCount >= 6:
		var coin: Button = SILVER_COIN.instantiate()
		get_tree().root.add_child(coin)
		coin.global_position = global_position
	money_timer.start(randf_range(5, 10))


func _on_button_button_down() -> void:
	state_transition.emit(state_machine.current_state, "pickUp")


func _on_button_button_up() -> void:
	state_transition.emit(state_machine.current_state, "wander")


func _on_tree_exited() -> void:
	game_manager.checkFishAmount()
