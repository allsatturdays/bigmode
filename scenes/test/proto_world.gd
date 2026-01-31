extends Node3D


func _on_area_3d_body_entered(body):
	if(body.is_in_group("player")):
		print('f')
		#var dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_test, "start")
		DialogueManager.show_example_dialogue_balloon(load("res://resources/dialogue/test.dialogue"), "start")
	
