extends Node2D
class_name Level

@export var tries:int = 3
@onready var current_tries:int = tries

@export var spawnpoint:Area2D

@onready var player_scene:PackedScene = load("res://Scenes/player.tscn")

func _ready() -> void:
	var players:Array[Node] = get_tree().get_nodes_in_group("Players")
	for player in players:
		if player != Global.current_player:
			player.queue_free()
	
	Global.current_player.velocity = Vector2.ZERO
	Global.current_player.global_position = spawnpoint.global_position
	Global.camera.global_position = Global.current_player.global_position
	
	Global.update_tries_hud.emit(current_tries, tries)

func kill_player():
	if current_tries <= 0:
		for player in get_tree().get_nodes_in_group("Players"):
			player.queue_free()
		current_tries = tries + 1
	
	var new:Player = player_scene.instantiate()
	new.modulate.a = 0.0
	
	Global.camera.shake_camera(1.0, 0.2)
	Global.main.add_child(new)
	Global.play_sfx.emit(load("res://Assets/SFX/hurt.wav"))
	
	new.global_position = spawnpoint.global_position
	
	Global.current_player = new
	
	current_tries -= 1
	
	Global.update_tries_hud.emit(current_tries, tries)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Die"):
		if spawnpoint.get_overlapping_bodies().has(Global.current_player) and not current_tries <= 0:
			# Tell the player they can't do that right now
			Global.current_player.nuh_uh.modulate.a = 1.0;
		else:
			kill_player()
