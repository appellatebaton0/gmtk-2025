extends GridContainer
class_name LevelSelector

signal selected_level(id:int)

var button_script:Script = load("res://Scripts/level_button.gd")
var buttons:Array[Button]
func _add_button() -> Button:
	var new:Button = Button.new()
	
	add_child(new)
	
	new.custom_minimum_size = Vector2(200, 200)
	new.text = str(get_child_count())
	
	new.add_theme_font_size_override("font_size", 140)
	new.set_script(button_script)
	
	new.disabled = true
	
	buttons.append(new)
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
			if child is Button:
				child.disabled = Global.progress < i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_complete.connect(_on_level_complete)
	start_up()
