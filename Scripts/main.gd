extends Node
class_name Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_selected.connect(_on_level_selected)

func _on_level_selected(id:int):
	for child in get_children():
		if child is Level:
			child.queue_free()
	
	var new_level:Level = Global.levels[id].instantiate()
	
	add_child(new_level)
