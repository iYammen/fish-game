extends Control

@export var fish: Array[entityResource]
@export var buttons: Array[Button]

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
	for i in buttons.size():
		var btn := buttons[i]
		btn.button_down.connect(Callable(self, "_on_shop_button_down").bind(i))



func showShop():
	for i in buttons.size():
		var btn := buttons[i]
		btn.text = "%s: %d" % [fish[i].name, fish[i].price * game_manager.discount]
		btn.icon = fish[i].portrait
	var grownGuppies: Array
	visible = true
	get_tree().paused = true
	allGuppies = get_tree().get_nodes_in_group("Guppy")
	for guppy in allGuppies:
		if guppy.feedCount >= 6:
			grownGuppies.append(guppy)
	currentGuppyArray = grownGuppies

func closeShop():
	visible = false
	get_tree().paused = false

func _on_shop_button_down(index: int):
	var data = fish[index]
	var discountedPrice = data.price * game_manager.discount
	if game_manager.money < discountedPrice:
		_display_error("not enough money to\nbuy stock")
		return
	
	game_manager.subtractCoin(discountedPrice)
	spawn_fish(data)

func spawn_fish(data: entityResource) -> void:
	var inst := data.spawnable.instantiate()
	get_tree().current_scene.add_child(inst)

	match data.id:
		1: 
			inst.global_position = Vector2(game_manager.GetDirection().x, 180)
		3:
			inst.global_position = Vector2(game_manager.GetDirection().x, 168)
		_:
			inst.global_position = game_manager.GetDirection()




func _display_error(msg: String) -> void:
	error_message_label.text = msg
	error_message.visible = true
	pop_up_timer.start()

func _on_pop_up_timer_timeout() -> void:
	error_message.visible = false


func _on_close_button_button_down() -> void:
	closeShop()


func _on_error_exit_button_button_down() -> void:
	error_message.visible = false
