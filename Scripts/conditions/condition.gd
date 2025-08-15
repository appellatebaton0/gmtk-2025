extends Resource
class_name Condition

signal updated(to:bool)

func get_actors() -> Array[Actor]:
	return []

# Provide an in to the SceneTree, ran by the Actor the condition is applied to.
func initialize(_with:Node):
	pass

func update(_to:bool = false):
	updated.emit(get_state())

func get_state() -> bool:
	return false
