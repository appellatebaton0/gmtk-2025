extends TileMapLayer
class_name Death
#
#@onready var level:Level = get_parent().get_parent()
#
## If the current spore is colliding.
#func player_within_range() -> bool:
	#return get_overlapping_bodies().has(Global.current_player)
#
#func _on_body_entered(body: Node2D) -> void:
	#if body == Global.current_player:
		#level.kill_player()
