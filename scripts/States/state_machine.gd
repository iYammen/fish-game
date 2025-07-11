extends Node
class_name stateMachine
@export var initial_state : State
#@onready var label: Label = $"../Label"

var current_state: State
var states: Dictionary = {}
var source_state_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float):
	#label.text = current_state.name
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func change_state (source_state: State, new_state_name: String):
	source_state_name = source_state.name
	if source_state != current_state:
		#print("invalid: trying to change from " + source_state.name + " to " + current_state.name)
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		#print("new state is empty")
		return
	
	#print("changed from " + source_state.name + " to " + new_state.name)
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state
