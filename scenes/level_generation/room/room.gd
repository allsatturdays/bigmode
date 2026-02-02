extends Node3D
class_name Room

@export var num_loot: int = 0
var num_loot_collected: int = 0

func _ready() -> void:
	GameEvents.on_loot_pickup.connect(_on_loot_pickup)
	num_loot_collected = 0


func _on_loot_pickup() -> void: 
	num_loot_collected += 1
	print('amount of loot collected: ', num_loot_collected)
