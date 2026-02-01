class_name MainMenu
extends Control

const VERSION_PREFIX: String = "v"

@onready var title_label: Label = %TitleLabel
@onready var author_label: Label = %AuthorLabel
@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton


func _ready() -> void:
	if OS.has_feature("web"):
		quit_menu_button.visible = false
