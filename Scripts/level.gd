extends Node2D
class_name Level

@export var tries:int = 3
@onready var current_tries:int = tries

@export var spawnpoint:Marker2D
@export var spawn_check_ray:RayCast2D

@onready var player_scene:PackedScene = load("res://Scenes/player.tscn")

func _ready() -> void:
	var players:Array[Node] = get_tree().get_nodes_in_group("Players")
	for player in players:
		if player != Global.current_player:
			player.queue_free()
	
	Global.current_player.velocity = Vector2.ZERO
	Global.current_player.global_position = spawnpoint.global_position
	
	Global.update_tries_hud.emit(current_tries, tries)

func kill_player():
	if current_tries <= 0:
		for player in get_tree().get_nodes_in_group("Players"):
			player.queue_free()
		current_tries = tries + 1
	
	var new:Player = player_scene.instantiate()
	new.modulate.a = 0.0
	
	Global.main.add_child(new)
	new.global_position = spawnpoint.global_position
	
	Global.current_player = new
	
	current_tries -= 1
	
	Global.update_tries_hud.emit(current_tries, tries)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Die"):
		if spawn_check_ray.is_colliding():
			# Tell the player they can't do that right now
			pass
		else:
			if current_tries <= 0:
				for player in get_tree().get_nodes_in_group("Players"):
					player.queue_free()
				current_tries = tries + 1
			
			var new:Player = player_scene.instantiate()
			new.modulate.a = 0.0
			
			Global.main.add_child(new)
			new.global_position = spawnpoint.global_position
			
			Global.current_player = new
			
			current_tries -= 1
			
			Global.update_tries_hud.emit(current_tries, tries)
