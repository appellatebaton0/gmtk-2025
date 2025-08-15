extends Node2D
class_name Actor

signal changed_state(to:bool)

@export var condition:Condition

var state:bool = false
var lock:bool = false

func on_change_state(_to:bool):
	pass
func change_state(to:bool):
	state = to
	changed_state.emit(state)
	on_change_state(to)

func on_change_lock(_to:bool):
	pass
func change_lock(to:bool):
	lock = to
	on_change_lock(to)

func ready() -> void:
	pass
func _ready() -> void:
	if condition == null:
		var parent:Node2D = get_parent()
		if parent is ActorGroup:
			condition = parent.condition
	if condition != null:
		condition.initialize(self)
		
		change_lock(condition.get_state())
		
		condition.updated.connect(change_lock)
		
	ready()
