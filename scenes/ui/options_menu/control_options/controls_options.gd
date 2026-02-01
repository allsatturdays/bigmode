extends MarginContainer

var _action_handler: ActionHandler = ActionHandler.new()


@onready var keybinds_map_margin_container: MarginContainer = %KeybindsMapMarginContainer



func _ready() -> void:
	_connect_signals()
	_init_action_handler()


func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuButton")
	_action_handler.register_action(MenuButtonEnum.ID.OPTIONS_MENU_RESET, _action_reset_menu_button)


func _action_reset_menu_button() -> void:
	if not is_visible_in_tree():
		return




func _connect_signals() -> void:
	GameEvents.menu_button_pressed.connect(_on_menu_button_pressed)



func _on_menu_button_pressed(id: MenuButtonEnum.ID, _source: MenuButtonClass) -> void:
	_action_handler.handle_action("MenuButton", id, self)
