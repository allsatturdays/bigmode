extends Node3D

@export var sprite_texture: CompressedTexture2D 

func _ready() -> void: 
	$Sprite3D.texture = sprite_texture

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.on_loot_pickup.emit()
		queue_free()
