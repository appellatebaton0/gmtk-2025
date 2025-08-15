extends Actor
class_name PressurePlate

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var area:Area2D = get_area()
func get_area() -> Area2D:
	var me = self
	if me is Area2D:
		return me
	return null

func _process(delta: float) -> void:
	
	if not lock and state != area.has_overlapping_bodies():
		change_state(area.has_overlapping_bodies())

func ready():
	anim.play("transition")

# Ran as an extension of change_state() that can be class-specific.
func on_change_state(to:bool):
	anim.play("transition")

func _on_animation_finished() -> void:
	if anim.animation == "transition": # Which, it really should be
		anim.play("down" if state else "up")
