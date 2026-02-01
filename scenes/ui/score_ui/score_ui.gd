extends CanvasLayer

@onready var score: int = 0
@onready var score_label: Label = $AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/ScoreValue

func _ready():
	GameEvents.connect("on_game_start", _on_game_start)
	GameEvents.connect("on_loot_pickup", _on_loot_pickup)
	


func _on_game_start() -> void:
	update_score_label()

func _on_loot_pickup() -> void:
	score += 100
	update_score_label()
	
func update_score_label() -> void:
	score_label.text = str(score)
