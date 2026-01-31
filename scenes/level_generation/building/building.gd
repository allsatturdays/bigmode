extends Node
class_name Building

@export var room_array: Array[String]
@export var debug_room_array: Array[String]
@export var is_in_debug_mode: bool = false

var rooms: Array[String] = []

var current_room: int = 2

func generate_rooms() -> void:
	if is_in_debug_mode:
		rooms = []
		rooms.push_front(debug_room_array.pick_random())
		rooms.push_front(debug_room_array.pick_random())
		rooms.push_front(debug_room_array.pick_random())
		current_room = rooms.size()-1
	else:
		rooms = []
		rooms.push_front(room_array.pick_random())
		rooms.push_front(room_array.pick_random())
		rooms.push_front(room_array.pick_random())
		current_room = rooms.size()-1
		print(rooms)

func next_room() -> String:
	if current_room == 0:
		GameEvents.on_building_complete.emit()
		generate_rooms()
		return rooms[current_room]
	else:
		current_room -= 1
		return rooms[current_room]
		
