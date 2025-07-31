extends Node

signal level_complete(raw:bool)
signal level_selected(id:int)

signal update_tries_hud(left:int, total:int)

@onready var main:Main = get_tree().get_first_node_in_group("Main")

func _level_complete(raw:bool = false):
	if raw:
		progress += 1
		level_complete.emit(false)

var levels:Array[PackedScene] = get_levels()
func get_levels() -> Array[PackedScene]:
	var path = "res://Scenes/Levels/"
	var dir = DirAccess.open(path)
	
	var list:Array[PackedScene]
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory..? " + file_name)
			else:
				print("found ", file_name)
				file_name = file_name.replace(".remap", "")
				
				list.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return list

var progress:int = 0


var allow_player_control:bool = true
@onready var current_player:Player = get_tree().get_first_node_in_group("Players")


func _ready() -> void:
	level_complete.connect(_level_complete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if allow_player_control and len(get_tree().get_nodes_in_group("Levels")) > 0:
		current_player.control(delta)
