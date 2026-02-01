extends CanvasLayer

var is_building_transition: bool = false
var is_in_dialogue: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.connect("on_building_complete", _on_building_complete)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)


func play_transition() -> void:
	GameEvents.on_transition_start.emit()
	if is_building_transition:
		play_building_transition1()
	else:
		play_room_transition()


func play_room_transition() -> void:
	anim_player.play("room_transition")
	
	
func play_building_transition1() -> void:
	anim_player.play("building_transition1")
	await anim_player.animation_finished
	Main.game_controller.dialogue_controller.start_dialogue()
	is_in_dialogue = true
	
func play_building_transition2() -> void:
	anim_player.play("building_transition2")
	await anim_player.animation_finished
	is_in_dialogue = false
	is_building_transition = false


func _on_building_complete() -> void:
	is_building_transition = true

func _on_dialogue_ended(resource: Resource) -> void:
	is_in_dialogue = false
	play_building_transition2()
	
func emit_transition_complete() -> void:
	GameEvents.emit_signal("on_transition_complete")
