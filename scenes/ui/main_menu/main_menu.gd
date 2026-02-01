extends CanvasLayer


func _on_play_pressed():
	hide()
	Main.game_controller.building.generate_rooms()
	Main.game_controller.change_3d_scene(Main.game_controller.building.rooms[Main.game_controller.building.current_room], true, false)
	Main.game_controller.change_gui_scene("res://scenes/ui/score_ui/score_ui.tscn", true, false)
	GameEvents.on_game_start.emit()

func _on_settings_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
