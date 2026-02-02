extends  Node
class_name GameController

@export var world_3d: Node3D
@export var world_2d: Node2D
@export var gui: Control
@export var building_container: Node
@export var first_building_path: String

var current_3d_scene
var current_2d_scene
var current_gui_scene
var current_building: Building
var next_room_path: String

var _action_handler: ActionHandler = ActionHandler.new()


@onready var scene_transition = $GUI/SceneTransition
@onready var dialogue_controller: DialogueController = $DialogueController
@onready var environment: WorldEnvironment = $Environment/WorldEnvironment
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.connect("on_player_death", _on_player_death)
	GameEvents.connect("on_room_complete", _on_room_complete)
	Main.game_controller = self
	current_gui_scene = $GUI/MenuScene
	current_building = $BuildingContainer/Building
	current_building.generate_rooms()
	

	

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new


func change_building_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> String:
	if current_building != null:
		if delete:
			current_building.queue_free()
		elif keep_running:
			current_building.visible = false
		else:
			building_container.remove_child(current_building)
	var new = load(new_scene).instantiate()
	building_container.add_child(new)
	current_building = new
	next_room_path = current_building.rooms[current_building.current_room]
	environment.environment.background_color = current_building.background_color
	
	return next_room_path
	
func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false )-> void:
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.visible = false
		else:
			world_3d.remove_child(current_3d_scene)
	var new = load(new_scene).instantiate()
	world_3d.add_child(new)
	current_3d_scene = new


func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false )-> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new


func _on_player_death() -> void:
	change_gui_scene("res://scenes/ui/game_over_ui/game_over_ui_scene.tscn", true, false)
	
	
func _on_room_complete(next_room: String) -> void:
	scene_transition.play_transition()
	play_spin_anim()
	#scene_transition.play_transition()
	change_3d_scene(next_room, true, false)
	

func play_spin_anim()-> void:
	anim_player.play("spin")
