extends Node
class_name Building

@export var room_array: Array[String]

var rooms: Array[String] = []

var current_room: int = 2

func generate_rooms() -> void:
	rooms.push_front(room_array.pick_random())
	rooms.push_front(room_array.pick_random())
	rooms.push_front(room_array.pick_random())
	current_room = rooms.size()-1
	print(rooms)

func next_room() -> String:
	if current_room == 0:
		rooms = []
		generate_rooms()
		return rooms[current_room]
	else:
		current_room -= 1
		return rooms[current_room]
