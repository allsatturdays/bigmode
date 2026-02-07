extends CanvasLayer

@onready var score: int = 0
@onready var score_label: Label = $AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/ScoreValue 
@onready var loot_label: Label = $AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
@onready var timer_label: Label = $Control2/TimerLabel
@onready var timer = $Timer



var _action_handler: ActionHandler = ActionHandler.new()
@onready var pause_menu: PauseMenu = %PauseMenu
@onready var options_menu: OptionsMenu = %OptionsMenu
var current_time: int = 10


func _ready():
	GameEvents.connect("menu_button_pressed", _on_menu_button_pressed)
	GameEvents.connect("on_game_start", _on_game_start)
	GameEvents.connect("on_loot_pickup", _on_loot_pickup)
	GameEvents.connect("on_room_start", _on_room_start)
	DialogueManager.connect("dialogue_started", _dialogue_started)
	DialogueManager.connect("dialogue_ended", _dialogue_ended)

	_init_action_handler()


func _process(delta):
	timer_label.text = str(snappedf(timer.time_left, 0.01) )

func _init_action_handler() -> void:
	_action_handler.set_register_type("MenuButton")
	_action_handler.register_actions(
		{
			MenuButtonEnum.ID.GAME_PAUSE: _action_game_pause_menu_button,
			MenuButtonEnum.ID.PAUSE_MENU_CONTINUE: _action_continue_menu_button,
			MenuButtonEnum.ID.PAUSE_MENU_OPTIONS: _action_options_menu_button,
			MenuButtonEnum.ID.PAUSE_MENU_LEAVE: _action_leave_menu_button,
			MenuButtonEnum.ID.PAUSE_MENU_QUIT: _action_quit_menu_button,
			MenuButtonEnum.ID.OPTIONS_MENU_BACK: _action_options_back_menu_button
		}
	)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_pause"):
		if get_tree().paused:
			if pause_menu.visible:
				Engine.time_scale = 1
				_action_continue_menu_button()
			else:
				_action_options_back_menu_button()
		else:
			_action_game_pause_menu_button()
			Engine.time_scale = 0


func _on_game_start() -> void:
	update_score_label()

func _on_loot_pickup() -> void:
	score += 1
	update_score_label()
	
func update_score_label() -> void:
	score_label.text = str(score)
	
	

func _action_game_pause_menu_button() -> void:
	#game_content.visible = true
	pause_menu.visible = true
	options_menu.visible = false
	get_tree().paused = true

	


func _action_continue_menu_button() -> void:
	#game_content.visible = true
	Engine.time_scale = 1
	pause_menu.visible = false
	options_menu.visible = false
	get_tree().paused = false

	


func _action_options_menu_button() -> void:
	#game_content.visible = false
	pause_menu.visible = false
	options_menu.visible = true


func _action_options_back_menu_button() -> void:
	#game_content.visible = true
	pause_menu.visible = true
	options_menu.visible = false


func _on_room_start(countdown_time: int) -> void:
	countdown_time = countdown_time
	timer_label.text = str(countdown_time)
	score = 0
	score_label.text = str(score)
	loot_label.text = "/" + str(Main.num_loot) + " loot"
	timer.start(countdown_time)
	

func _action_leave_menu_button() -> void:
	_action_continue_menu_button()
	process_mode = PROCESS_MODE_DISABLED
	Main.game_controller.change_gui_scene("res://scenes/ui/main_menu/menu_scene.tscn", true, false)


func _action_quit_menu_button() -> void:
	get_tree().quit()
	

func _on_menu_button_pressed(id: MenuButtonEnum.ID, _source: MenuButtonClass) -> void:
	_action_handler.handle_action("MenuButton", id, self)


func _on_timer_timeout() -> void:
	GameEvents.on_player_death.emit()
	

func _dialogue_started(_resource):
	timer.paused = true
	

func _dialogue_ended(_resource):
	timer.paused = false
