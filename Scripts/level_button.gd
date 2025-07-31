extends Button
class_name LevelButton

func _pressed() -> void:
	Global.level_selected.emit(get_index())
func _ready() -> void:
	pressed.connect(_pressed)
