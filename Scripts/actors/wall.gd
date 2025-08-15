extends Actor
class_name Wall

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var coll:CollisionPolygon2D = $CollisionPolygon2D

func ready():
	anim.play("transition", -1.0 if lock else 1.0, lock)

# Ran as an extension of change_lock() that can be class-specific.
func on_change_lock(to:bool):
	coll.set_deferred("disabled", not to)
	anim.play("transition", -1.0 if to else 1.0 , to)

func _on_animation_finished() -> void:
	if anim.animation == "transition": # Which, it really should be
		anim.play("down" if not lock else "up")
