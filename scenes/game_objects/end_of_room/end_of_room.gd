extends Node3D

var is_active: bool = false

func _ready() -> void:
	GameEvents.on_player_death.connect(_on_player_death)
	GameEvents.on_all_loot_found.connect(_on_all_loot_found)

func _on_static_body_3d_body_entered(body):
	if body.is_in_group("player") and is_active:
		GameEvents.on_room_complete.emit(Main.game_controller.current_building.next_room())

func _on_player_death() -> void:
	is_active = false


func _on_all_loot_found() -> void:
	is_active = true
