extends Area2D
class_name Rot

@export var prompt:CanvasItem

var used:bool = false

# If the current spore is colliding.
func player_within_range() -> bool:
	return get_overlapping_bodies().has(Global.current_player)

func _process(delta: float) -> void:
	if player_within_range():
		prompt.modulate.a = move_toward(prompt.modulate.a, 1, delta * 4)
		
		if Input.is_action_just_pressed("Interact") and not used:
			Global.level_complete.emit(true)
			used = true
			
	else:
		prompt.modulate.a = move_toward(prompt.modulate.a, 0, delta * 4)
