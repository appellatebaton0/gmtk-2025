extends Condition
class_name AND

@export var conditions:Array[Condition]

func get_actors() -> Array[Actor]:
	var actors:Array[Actor]
	
	for condition in conditions:
		actors.append(condition.get_actor())
	
	return actors

# In everything but actor, this just passes down the initialization to its subconditions and grabs the update signal to pass it on
func initialize(with:Node):
	for condition in conditions:
		condition.initialize(with)
		
		condition.updated.connect(update)

func get_state() -> bool:
	var state = true
	
	for condition in conditions:
		if not condition.get_state():
			state = false
	
	return state
