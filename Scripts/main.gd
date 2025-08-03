extends Node
class_name Main

# Audio

const MAX_SFX_PLAYERS:int = 5
@onready var sfx_handler:Node = $SFXHandler
func _play_sfx(sfx:AudioStream, pitch_scale:float = 1.0): 	
	var player_count:int = 0
	
	for child in sfx_handler.get_children():
		if child is AudioStreamPlayer:
			player_count += 1
			if not child.playing:
				child.stream = sfx
				child.pitch_scale = pitch_scale
				child.play()
				return
	
	if player_count < MAX_SFX_PLAYERS:
		var new:AudioStreamPlayer = AudioStreamPlayer.new()
		sfx_handler.add_child(new)
		
		new.bus = &"SFX"
		
		new.stream = sfx
		new.pitch_scale = pitch_scale
		new.play()

const TRANSITION_SPEED:float = 50
@onready var music_handler_a:AudioStreamPlayer = $BackgroundMusicHandler/StreamA
@onready var music_handler_b:AudioStreamPlayer = $BackgroundMusicHandler/StreamB
var music_switch:bool = true
func _play_music(music:AudioStream):
	music_switch = not music_switch
	if music_switch:
		music_handler_a.volume_db = -40
		music_handler_b.volume_db = 0
		
		music_handler_a.stream = music.duplicate()
		music_handler_a.play()
	else:
		music_handler_b.volume_db = -40
		music_handler_a.volume_db = 0
		
		music_handler_b.stream = music.duplicate()
		music_handler_b.play()

func _process(delta: float) -> void:
	# Audio
	
	if music_switch:
		music_handler_a.volume_db = move_toward(music_handler_a.volume_db, 0, delta * TRANSITION_SPEED)
		music_handler_b.volume_db = move_toward(music_handler_b.volume_db, -40, delta * TRANSITION_SPEED)
	else:
		music_handler_b.volume_db = move_toward(music_handler_b.volume_db, 0, delta * TRANSITION_SPEED)
		music_handler_a.volume_db = move_toward(music_handler_a.volume_db, -40, delta * TRANSITION_SPEED)
	


@export var default_scene:Node3D
var current_scene:Node3D
var flashback:PackedScene
func _on_event_trigger(event_name:String):
	match event_name:
		"flashback_load":
			var new:Node3D = flashback.instantiate()
			
			if current_scene == default_scene:
				current_scene.hide()
				current_scene.global_position.y -= 2000.0 # Because turning off collision is a pain, just yeet it.
			else:
				current_scene.queue_free()
			
			add_child(new)
			
			current_scene = new
		"hub_load":
			if current_scene != default_scene:
				current_scene.queue_free()
				
				current_scene = default_scene
				current_scene.show()
				current_scene.global_position.y += 2000.0 # Because turning off collision is a pain, just yeet it.
			
func _on_set_flashback(scene:PackedScene):
	flashback = scene


func _ready() -> void:
	# Wire AudioManager
	Global.play_sfx.connect(_play_sfx)
	Global.play_background_music.connect(_play_music)
	
	# Start theme music
	Global.play_background_music.emit(load("res://Assets/Music/theme.ogg"))
	Global.level_selected.connect(_on_level_selected)

## --

func _on_level_selected(id:int):
	for child in get_children():
		if child is Level:
			child.queue_free()
	
	var new_level:Level = Global.levels[id].instantiate()
	
	add_child(new_level)
