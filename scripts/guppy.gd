extends RigidBody2D
class_name Guppy

@export var nameRes: nameResource
@export var hungerTimerRange: Vector2
@export var hungerAdultTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent
var move_t := 0.0
var hunger_t := 0.0
var money_t := 0.0
var is_hungry := false

@onready var blood: AnimatedSprite2D = $blood
@onready var name_label: Label = $nameLabel
@onready var button: Button = $Button


var feedCount: int = 0
var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
@onready var state_machine: stateMachine = $state_machine
signal state_transition
var hunger_state := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_transition.connect(state_machine.change_state)
	input_pickable = true
	name_label.visible = false
	set_random_name()
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	move_t   = randf_range(0.3, 4.0)
	hunger_t = randf_range(hungerTimerRange.x, hungerTimerRange.y)
	money_t  = randf_range(5.0, 10.0)

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

func _physics_process(delta: float) -> void:
	print(is_hungry)
	move_t -= delta
	hunger_t -= delta
	if makingMoney:
		money_t -= delta

	if move_t <= 0.0:
		state_transition.emit(state_machine.current_state, "wander")
		move_t = randf_range(0.3, 4.0)

	if hunger_t <= 0.0:
		die()
	else:
		_update_hunger_tint()
	
	if hunger_t < hungerTimerRange.y / 1.5:
		is_hungry = true

	if makingMoney and money_t <= 0.0:
		_on_money_timer_timeout()
		money_t = randf_range(5.0, 10.0)


func _update_hunger_tint() -> void:
	var ratio := hunger_t / hungerTimerRange.y
	var s := 2 if ratio < 1.0 / 3.0 else 1 if ratio < 0.5 else 0
	if s == hunger_state:
		return
	hunger_state = s
	sprite_2d.modulate = [Color.WHITE, Color.LIME, Color.DARK_GREEN][s]


func checkFoodCount():
	if !makingMoney and feedCount >= 3:
		money_t = randf_range(5, 10)
		makingMoney = true
	if feedCount >= 3 and feedCount < 6:
		sprite_2d.frame = 1
	elif feedCount >= 6:
		sprite_2d.frame = 2
		hungerTimerRange = hungerAdultTimerRange

func die():
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	blood.play("default")
	sprite_2d.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	if get_tree().get_nodes_in_group("Fish Dead Component").is_empty() != true:
		var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
		for component in fishDeadComponents:
			component.AddMult()
	await get_tree().create_timer(0.8).timeout
	queue_free()

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
	money_t = randf_range(5, 10)


func _on_button_button_down() -> void:
	state_transition.emit(state_machine.current_state, "pickUp")


func _on_button_button_up() -> void:
	state_transition.emit(state_machine.current_state, "wander")


func _on_tree_exited() -> void:
	game_manager.checkFishAmount()
