extends Control

@export var fish: Array[entityResource]
@export var buttons: Array[Button]
@onready var spin_box: SpinBox = $bulkBuyWindow/SpinBox

var game_manager: GameManager
var allGuppies: Array
var currentGuppyArray: Array
var errorMessage: Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	errorMessage =  get_tree().get_first_node_in_group("Error Message")
	visible = false
	for i in buttons.size():
		var btn := buttons[i]
		btn.button_down.connect(Callable(self, "_on_shop_button_down").bind(i))
		buttons[i].tooltip_text = fish[i].desc

func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("pause"):
			closeShop()

func showShop():
	spin_box.value = 1
	updateDisabledButtons()
	for i in buttons.size():
		var btn := buttons[i]
		var data = fish[i]
		if data.moneyType.contains("$"):
			btn.text = "%s: %s %s" % [data.name, game_manager.abriviateNum(floor(data.price * game_manager.discount)), fish[i].moneyType]
		else:
			btn.text = "%s: %s %s" % [data.name, game_manager.abriviateNum(floor(data.price)), data.moneyType]
		btn.icon = fish[i].portrait
		
	
	visible = true
	get_tree().paused = true

func closeShop():
	visible = false
	get_tree().paused = false

func _on_shop_button_down(index: int):
	var grownGuppies: Array
	allGuppies = get_tree().get_nodes_in_group("Guppy")
	for guppy in allGuppies:
		if guppy.grown_state >= 2:
			grownGuppies.append(guppy)
	currentGuppyArray = grownGuppies
	
	var data = fish[index]
	if data.moneyType.contains("$"):
		var discountedPrice = data.price * game_manager.discount
		if game_manager.money < discountedPrice * spin_box.value:
			AudioManager.playError()
			errorMessage.showError("Error:" ,"Not enough money to buy", 0)
			return
		else:
			AudioManager.playSplash()
		game_manager.subtractCoin(discountedPrice * spin_box.value)
	else:
		if currentGuppyArray.size() < data.price * spin_box.value:
			AudioManager.playError()
			errorMessage.showError("Error:" ,"Not enough Guppys to buy", 0)
			return
		else:
			AudioManager.playSplash()
			var price: int = data.price * spin_box.value
			for i in price:
				currentGuppyArray[i].die()
			currentGuppyArray.clear()
	AudioManager.playButtonClick()
	for i in spin_box.value:
		spawn_fish(data)
	updateDisabledButtons()

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


func updateDisabledButtons():
	var grownGuppies: Array
	allGuppies = EntityManager.allGuppies
	for guppy in allGuppies:
		if guppy.grown_state >= 2:
			grownGuppies.append(guppy)
	currentGuppyArray = grownGuppies
	
	for i in buttons.size():
		var btn := buttons[i]
		var data = fish[i]
		if data.moneyType.contains("$"):
			var discountedPrice = data.price * game_manager.discount
			if game_manager.money < discountedPrice * spin_box.value:
				btn.disabled = true
			else:
				btn.disabled = false
		else:
			var price: int = data.price * spin_box.value
			if currentGuppyArray.size() < price:
				btn.disabled = true
			else:
				btn.disabled = false


func _on_close_button_button_down() -> void:
	AudioManager.playButtonClick()
	closeShop()



func _on_spin_box_value_changed(_value: float) -> void:
	updateDisabledButtons()
