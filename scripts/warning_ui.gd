extends Control

var number: int
var warningPanels: Array[Panel]
var boundsX: Vector2 = Vector2(-192.0, 104.0)
var boundsY: Vector2 = Vector2(-144.0, 72.0)
const WARNING_UI_PANEL = preload("res://scenes/UI/warningUIPanel.tscn")

func _ready() -> void:
	pass

func ShowAll():
	var ins: Panel = WARNING_UI_PANEL.instantiate()
	add_child(ins)
	ins.global_position = Vector2(randf_range(boundsX.x, boundsX.y),randf_range(boundsY.x, boundsY.y))
	warningPanels.append(ins)

func Hide():
	for warning in warningPanels:
		warning.queue_free()
	warningPanels.clear()
