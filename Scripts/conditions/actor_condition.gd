extends Condition
class_name ACTOR

@export var actor:NodePath
var act_node:Actor

func get_actors() -> Array[Actor]:
	return [act_node]

# Provide an in to the SceneTree, ran by the Actor the condition is applied to.
func initialize(with:Node):
	act_node = with.get_node(actor)
	if act_node != null:
		act_node.changed_state.connect(update)
	else:
		print("ERROR! ", with, "doesn't have a valid condition")

func get_state() -> bool:
	if act_node == null:
		return false
	return act_node.state
