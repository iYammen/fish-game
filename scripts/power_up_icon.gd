extends TextureRect
class_name powerUpIcon

@export var id: int = 0
@onready var label: Label = $Label
var count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func addCount():
	count += 1
	visible = true
	if count > 1:
		label.text = str(count)

func removeCount():
	count -= 1
	if count == 0:
		visible = false
	if count > 1:
		label.text = str(count)
