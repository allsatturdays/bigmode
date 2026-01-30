extends Node3D

func _on_static_body_3d_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.on_room_complete.emit(Main.game_controller.building.next_room())
