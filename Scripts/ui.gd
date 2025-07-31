extends Control
class_name UI

var state:String = "splash"
@onready var animator:AnimationPlayer = $AnimationPlayer

@onready var tries_hud:HBoxContainer = $MarginContainer/TriesHUD

func _ready() -> void:
	Global.level_selected.connect(_on_level_selected)
	Global.level_complete.connect(_on_level_completed)
	Global.update_tries_hud.connect(_update_tries_hud)

func _update_tries_hud(left:int, total:int):
	if tries_hud.get_child_count() != total:
		for child in tries_hud.get_children():
			child.queue_free()
		
		for i in range(total):
			var new:TextureRect = TextureRect.new()
			
			var texture:AtlasTexture = AtlasTexture.new()
			texture.atlas = load("res://Assets/Textures/spore.png")
			texture.region.size = Vector2i(24, 24)
			
			new.texture = texture
			new.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			new.custom_minimum_size = Vector2i(150, 150)
			
			tries_hud.add_child(new)
	var spores:Array[Node] = tries_hud.get_children()
	for i in range(len(spores)):
		var spore = spores[i]
		if spore is TextureRect:
			if spore.texture is AtlasTexture:
				spore.texture.region.position = Vector2(0, 0) if left > i else Vector2(24, 0)
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"splash_to_main":
			state = "main"
		"main_to_levels":
			state = "levels"
		"game_to_levels":
			state = "levels"
		"levels_to_game":
			state = "game"
	pass

func _on_levels_pressed() -> void:
	animator.play("main_to_levels")
func _on_level_selected(_id:int) -> void:
	match state:
		"levels":
			animator.play("levels_to_game")
		"main":
			animator.play("levels_to_game")
		"game":
			pass
		
func _on_level_completed(_id:int) -> void:
	match state:
		"game":
			animator.play("game_to_levels")
