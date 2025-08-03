extends TextureButton
class_name LevelButton

@onready var label:Label = $Label

const DELAY:float = 0.5
var delay:float = 0.0
var default_material:Material

func _process(delta: float) -> void:
	label.material = default_material if is_hovered() else null
	label.visible = not disabled
	delay = move_toward(delay, 0, delta)
func _pressed() -> void:
	if delay <= 0:
		Global.play_sfx.emit(load("res://Assets/SFX/press.wav"))
		Global.level_selected.emit(get_index())
		
		delay = DELAY
func _ready() -> void:
	default_material = label.material
	pressed.connect(_pressed)
