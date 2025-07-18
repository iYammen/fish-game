extends Node2D
class_name Guppy

var chosenName: String = ""
@export var nameRes: nameResource
var hungerWaitTime: float = 0
@export var hungerTimerRange: Vector2
@export var hungerAdultTimerRange: Vector2
@export var moneyTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent

var move_t := 0.0
var hunger_t := 0.0
var money_t := 0.0
var is_hungry := false


var feedCount: int = 0
var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
@onready var state_machine: stateMachine = $state_machine
signal state_transition
var hunger_state := 0
var tintCheck_t: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_transition.connect(state_machine.change_state)
	#set_random_name()
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	move_t = randf_range(0.3, 4.0)
	hungerWaitTime = randf_range(hungerTimerRange.x, hungerTimerRange.y)
	hunger_t = hungerWaitTime
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
	tintCheck_t = randf_range(2, 5)
	checkFoodCount()

#func set_random_name() -> void:
	#var parts: int = randi_range(1, 3)
#
	#var names_copy: Array = nameRes.names.duplicate()
	#names_copy.shuffle()
	#var chosen: Array = names_copy.slice(0, parts)
	#
	#if chosen.size() >= 2 and randi_range(1, 3) == 1:  # 10 % roll
			## Check whether any article is already inside the chosen words
			#var lower_chosen: Array = chosen.map(func(n): return String(n).to_lower())
			#var article_found: bool = false
			#for art in nameRes.articles:
				#if lower_chosen.has(art.to_lower()):
					#article_found = true
					#break
			#
			## Insert only if none were found
			#if not article_found and nameRes.articles.size() > 0:
				#var article: String = nameRes.articles[randi_range(0, nameRes.articles.size() - 1)]
				#chosen.insert(chosen.size() - 1, article)  # before the last name
#
	#chosenName = " ".join(chosen)

func _physics_process(delta: float) -> void:
	move_t -= delta
	hunger_t -= delta
	tintCheck_t -= delta
	if hunger_t <= 0.0:
		die()
	else:
		is_hungry = hunger_t < hungerWaitTime * 0.66
		if tintCheck_t <= 0:
			_update_hunger_tint()
			tintCheck_t = randf_range(0, 1)
	
	if makingMoney:
		money_t -= delta
		if money_t <= 0.0:
			_on_money_timer_timeout()
			money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)


func _update_hunger_tint() -> void:
	var ratio := hunger_t / hungerWaitTime
	var s := 2 if ratio < 1.0 / 3.0 else 1 if ratio < 0.5 else 0
	if s == hunger_state:
		return
	hunger_state = s
	sprite_2d.modulate = [Color.WHITE, Color.LIME, Color.DARK_GREEN][s]


func checkFoodCount():
	if !makingMoney and feedCount >= 4:
		money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
		makingMoney = true
	if feedCount >= 4 and feedCount < 10:
		sprite_2d.frame = 1
	elif feedCount >= 10:
		sprite_2d.frame = 2
		hungerTimerRange = hungerAdultTimerRange

func die():
	reuseManager.createBlood(global_position)
	sprite_2d.visible = false
	if get_tree().get_nodes_in_group("Fish Dead Component").is_empty() != true:
		var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
		for component in fishDeadComponents:
			component.AddMult()
	queue_free()

func _on_money_timer_timeout() -> void:
	if feedCount >= 4 and feedCount < 10:
		reuseManager.createBronzeCoin(global_position)
	elif feedCount >= 10:
		reuseManager.createSilverCoin(global_position)
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)


func _on_tree_exited() -> void:
	game_manager.checkFishAmount()
