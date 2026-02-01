# Emits audio events on target slider signals (cell selected, button clicked).
# Attach to parent node.
class_name TreeAudio
extends Node

## Sets target as parent if target is not already set.
@export var target: Tree

@export_category("Sounds")
@export var cell_selected: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var button_clicked: AudioEnum.Sfx = AudioEnum.Sfx.CLICK


func _ready() -> void:
	if target == null:
		target = get_parent()

	_connect_signals()


func _connect_signals() -> void:
	target.cell_selected.connect(_on_cell_selected)
	target.button_clicked.connect(_on_button_clicked)


func _on_cell_selected() -> void:
	if _is_set(cell_selected):
		AudioManager.play_sfx(cell_selected)



func _on_button_clicked(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	if _is_set(button_clicked):
		AudioManager.play_sfx(button_clicked)



func _is_set(event: AudioEnum.Sfx) -> bool:
	return target != null and event != AudioEnum.Sfx.NULL
