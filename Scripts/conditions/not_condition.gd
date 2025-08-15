extends Condition
class_name NOT

@export var condition:Condition

func get_actors() -> Array[Actor]:
	return [condition.get_actor()]

# In everything but actor, this just passes down the initialization to its subconditions and grabs the update signal to pass it on
func initialize(with:Node):
	condition.initialize(with)
	
	condition.updated.connect(update)

func get_state() -> bool:
	return not condition.get_state()
