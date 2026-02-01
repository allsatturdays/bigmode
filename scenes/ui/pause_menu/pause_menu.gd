class_name PauseMenu
extends Control

@onready var quit_menu_button: MenuButtonClass = $MarginContainer/VBoxContainer/VBoxContainer2/MenuButton4


func _ready() -> void:
	if OS.has_feature("web"):
		quit_menu_button.visible = false
