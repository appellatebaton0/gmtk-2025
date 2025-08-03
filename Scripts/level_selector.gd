extends GridContainer
class_name LevelSelector

signal selected_level(id:int)

var button_scene:PackedScene = load("res://Scenes/level_button.tscn")
func _add_button() -> TextureButton:
	# Make the button
	var new:LevelButton = button_scene.instantiate()
	
	add_child(new)
	
	new.label.text = str(get_child_count())
	
	return new

func start_up():
	for i in range(len(Global.levels)):
		var new = _add_button()
		new.disabled = Global.progress < i

func _on_level_complete(raw:bool):
	if not raw: # If everything you need is taken care of
		var children = get_children()
		for i in range(len(children)):
			var child = children[i]
			if child is LevelButton:
				child.disabled = Global.progress < i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_complete.connect(_on_level_complete)
	start_up()
