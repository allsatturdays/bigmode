extends Node
class_name Building

@export var room_array: Array[String]
@export var debug_room_array: Array[String]
@export var is_in_debug_mode: bool = false
@export var next_building_path: String
@export var building_start_dialogue: DialogueResource
@export var background_color: Color

var rooms: Array[String] = []
var current_room: int

func _ready():
	generate_rooms()

func generate_rooms() -> void:
	if is_in_debug_mode:
		rooms = debug_room_array
		current_room = rooms.size()-1
	else:
		rooms = room_array
		current_room = rooms.size()-1
	current_room = room_array.size() - 1

func next_room() -> String:
	if current_room == 0:
		GameEvents.on_building_complete.emit()
		return Main.game_controller.change_building_scene(next_building_path, true, false)

	else:
		current_room -= 1
		return rooms[current_room]
	
		
