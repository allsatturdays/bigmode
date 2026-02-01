extends Node3D

var is_active: bool = true

func _ready() -> void:
	GameEvents.on_player_death.connect(_on_player_death)


func _on_static_body_3d_body_entered(body):
	if body.is_in_group("player") and is_active:
		GameEvents.on_room_complete.emit(Main.game_controller.building.next_room())

func _on_player_death() -> void:
	is_active = false
