extends Camera2D
class_name Camera

const dampening:Vector2 = Vector2(4.0, 16.0)
const follow_ahead:float = 0.2

var follow_y:float = 0.0

func get_follow_point() -> Vector2:
	var player:Player = Global.current_player
	
	if player.is_on_floor():
		follow_y = player.global_position.y
	follow_y = player.global_position.y
	
	return Vector2((player.global_position + (player.velocity * follow_ahead)).x, follow_y)

var shake_amount:float = 0.0
var shake_duration:float = 0.0
func shake_camera(amount:float, duration:float):
	shake_amount = amount
	shake_duration = duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var camera_shake:Vector2 = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
	
	global_position += (get_follow_point() - global_position) / dampening + camera_shake
	
	if shake_amount != 0:
		shake_duration = move_toward(shake_duration, 0, delta)
		if shake_duration == 0:
			shake_amount = 0
