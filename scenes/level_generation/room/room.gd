extends Node3D
class_name Room

@export var num_loot: int = 0
@export var countdown_time: int = 10
var num_loot_collected: int = 0

func _ready() -> void:
	GameEvents.on_loot_pickup.connect(_on_loot_pickup)
	num_loot_collected = 0
	Main.num_loot = num_loot
	GameEvents.on_room_start.emit(10)




func _on_loot_pickup() -> void: 
	num_loot_collected += 1
	if num_loot == num_loot_collected:
		GameEvents.on_all_loot_found.emit()
	
