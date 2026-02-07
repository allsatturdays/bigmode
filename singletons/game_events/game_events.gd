extends Node


# In Game Signals
signal on_room_complete()
signal on_building_complete()
signal on_item_pickup()
signal on_player_move(player_start_position: Vector3, player_direction_position: Vector3)
signal on_transition_complete()
signal on_transition_start()
signal on_player_death()
signal on_game_start()
signal on_loot_pickup()
signal on_room_start(countdown_time: int)
signal on_all_loot_found()


# UI signals
signal menu_button_pressed(id: MenuButtonEnum.ID, source: MenuButtonClass)
signal menu_slider_value_changed(id: MenuSliderEnum.ID, value: float, source: MenuSlider)
signal menu_toggle_value_changed(id: MenuToggleEnum.ID, enabled: bool, source: MenuToggle)
