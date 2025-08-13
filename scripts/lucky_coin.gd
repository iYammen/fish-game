extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("addSelf")

func addSelf():
	EntityManager.allLuckyCoinComponents.append(self)
