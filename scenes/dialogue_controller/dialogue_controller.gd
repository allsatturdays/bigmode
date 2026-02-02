extends Node
class_name DialogueController

func start_dialogue() -> void:
	DialogueManager.show_example_dialogue_balloon(Main.game_controller.current_building.building_start_dialogue, "start")
