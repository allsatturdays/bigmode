extends CanvasLayer


func _on_play_pressed():
	Main.game_controller.building.generate_rooms()
	Main.game_controller.change_3d_scene(Main.game_controller.building.rooms[Main.game_controller.building.current_room], true, false)
	GameEvents.on_game_start.emit()
	hide()


func _on_settings_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
