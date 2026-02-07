extends Node

var game_controller: GameController
var num_loot: int = 0
var can_open_door: bool = false


#func _ready() -> void:
	#GameEvents.connect("on_all_loot_found", _on_all_loot_found)
	#GameEvents.connect("on_room_start", _on_room_start)
	#
#
#func _on_all_loot_found() -> void:
	#can_open_door = true
#
#
#func _on_room_start() -> void: 
	#can_open_door = false
