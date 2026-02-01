extends Control
class_name GameOverUI


@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton


func _ready() -> void:
	if OS.has_feature("web"):
		quit_menu_button.visible = false
