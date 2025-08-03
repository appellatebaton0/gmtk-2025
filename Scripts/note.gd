extends Area2D
class_name Note

@export var fade:CanvasItem

func _process(delta: float) -> void:
	fade.modulate.a = move_toward(fade.modulate.a, 1 if get_overlapping_bodies().has(Global.current_player) else 0, delta * 4)
