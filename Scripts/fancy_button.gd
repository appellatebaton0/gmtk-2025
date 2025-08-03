extends TextureButton

var default_material:Material

func _ready() -> void:
	default_material = $Label.material

func _process(_delta: float) -> void:
	$Label.material = default_material if is_hovered() else null
