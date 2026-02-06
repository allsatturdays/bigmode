class_name GameOverMenu
extends Control

const VERSION_PREFIX: String = "v"

@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton
var _action_handler: ActionHandler = ActionHandler.new()
var _current_menu: Control = null

@onready var game_over_menu: GameOverUI = $GameOverMenu
@onready var options_menu: OptionsMenu = %OptionsMenu

func _ready() -> void:
	GameEvents.menu_button_pressed.connect(_on_menu_button_pressed)
	_toggle_menu(game_over_menu)
	_init_action_handler()
	


func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuButton")
	_action_handler.register_actions(
		{
			MenuButtonEnum.ID.MAIN_MENU_PLAY: _action_game_over_menu_play,
			MenuButtonEnum.ID.MAIN_MENU_OPTIONS: _action_game_over_menu_options,
			MenuButtonEnum.ID.MAIN_MENU_QUIT: _action_game_over_menu_quit, 
			MenuButtonEnum.ID.OPTIONS_MENU_BACK: _action_game_over_menu_back
		}
	)


func _action_game_over_menu_back() -> void:
	_toggle_menu(game_over_menu)

func _toggle_menu(menu: Control) -> void:
	menu.visible = true
	if _current_menu != null:
		_current_menu.visible = false
	_current_menu = menu


func _action_game_over_menu_quit() -> void:
	get_tree().quit()


func _action_game_over_menu_options() -> void:
	_toggle_menu(options_menu)


func _action_game_over_menu_play() -> void:
	AudioManager.stop_music()
	await get_tree().create_timer(.5).timeout
	AudioManager.play_music(AudioEnum.Music.BGM)
	#Main.game_controller.change_gui_scene("res://scenes/ui/scene_transition/scene_transition.tscn", true, false)
	Main.game_controller.play_spin_anim()
	Main.game_controller.change_building_scene(Main.game_controller.first_building_path, true, false)
	Main.game_controller.current_building.generate_rooms()
	Main.game_controller.change_3d_scene(Main.game_controller.current_building.rooms[Main.game_controller.current_building.current_room], true, false)
	Main.game_controller.change_gui_scene("res://scenes/ui/score_ui/score_ui.tscn", true, false)
	GameEvents.on_game_start.emit()


func _on_menu_button_pressed(id: MenuButtonEnum.ID, _source: MenuButtonClass) -> void:
	_action_handler.handle_action("MenuButton", id, self)
