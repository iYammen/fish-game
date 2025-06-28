extends Control

@export var fish: Array[entityResource]
var game_manager: GameManager
var allGuppies: Array
var currentGuppyArray: Array
@onready var pop_up_timer: Timer = $popUpTimer
@onready var error_message: Panel = $"Error Message"
@onready var error_message_label: Label = $"Error Message/errorMessageLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	visible = false
	error_message.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("press"):
		visible = false
		get_tree().paused = false

func showShop():
	var grownGuppies: Array
	visible = true
	get_tree().paused = true
	allGuppies = get_tree().get_nodes_in_group("Guppy")
	for guppy in allGuppies:
		if guppy.feedCount >= 6:
			grownGuppies.append(guppy)
	currentGuppyArray = grownGuppies
	game_manager.exitingScreen = true

func spawn(number: int):
	match fish[number].id:
		0:
			var spawn:= fish[number].spawnable.instantiate()
			get_tree().current_scene.add_child(spawn)
			spawn.global_position = game_manager.GetDirection()
		1:
			var spawn:= fish[number].spawnable.instantiate()
			get_tree().current_scene.add_child(spawn)
			spawn.global_position.y = 180
			spawn.global_position.x = game_manager.GetDirection().x
		2:
			var spawn:= fish[number].spawnable.instantiate()
			get_tree().current_scene.add_child(spawn)
			spawn.global_position = game_manager.GetDirection()
		3:
			var spawn:= fish[number].spawnable.instantiate()
			get_tree().current_scene.add_child(spawn)
			spawn.global_position.y = 168
			spawn.global_position.x = game_manager.GetDirection().x



func _on_button_2_button_down() -> void:
	if game_manager.money >= 20:
		game_manager.subtractCoin(20)
		spawn(0)
	else:
		displayError("not enough money to\nbuy stock")


func _on_button_3_button_down() -> void:
	if game_manager.money >= 40:
		game_manager.subtractCoin(40)
		spawn(1)
	else:
		displayError("not enough money to\nbuy stock")


func _on_button_button_down() -> void:
	if currentGuppyArray.size() > 2:
		for i in 3:
			currentGuppyArray[i].die()
		spawn(2)
	else:
		displayError("not enough Guppies to\nbuy stock")


func _on_button_4_button_down() -> void:
	if game_manager.money >= 100:
		game_manager.subtractCoin(100)
		spawn(3)
	else:
		displayError("not enough money to\nbuy stock")

func displayError(message: String):
	pop_up_timer.start()
	error_message_label.text = message
	error_message.visible = true

func _on_pop_up_timer_timeout() -> void:
	error_message.visible = false
