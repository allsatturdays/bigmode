extends Node
class_name DialogueController

func start_dialogue() -> void:
	DialogueManager.show_example_dialogue_balloon(load("res://resources/dialogue/test.dialogue"), "start")
