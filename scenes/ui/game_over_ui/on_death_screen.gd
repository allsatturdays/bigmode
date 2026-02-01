extends CanvasLayer

func _on_restart_button_pressed():
	Main.game_controller.building.generate_rooms()
	Main.game_controller.change_3d_scene(Main.game_controller.building.rooms[Main.game_controller.building.current_room], true, false)
	GameEvents.on_game_start.emit()
	hide()
