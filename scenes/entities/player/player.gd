extends CharacterBody3D

@export var dash_speed: float = 60.0 * .7
@export var grid_size: float = .5
@export var new_room_control_freeze_time: float = .5 

var can_control: bool = false
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D


func _ready() -> void:
	sprite.play("default")
	GameEvents.connect("on_transition_start", _on_transition_start)
	GameEvents.connect("on_transition_complete", _on_transition_complete)
	GameEvents.connect("on_game_start", _on_game_start)
	GameEvents.connect("on_player_death", _on_player_death)
	
	position = Vector3(
		round(position.x / grid_size) * grid_size,
		position.y,
		round(position.z / grid_size) * grid_size
	)
	target_position = position

func _physics_process(delta: float) -> void:
	if not can_control:
		return
	if is_dashing:
		velocity = dash_direction * dash_speed
		move_and_slide()
		
		if get_slide_collision_count() > 0:
			position = Vector3(
				round(position.x / grid_size) * grid_size,
				position.y,
				round(position.z / grid_size) * grid_size
			)
			
			is_dashing = false
			sprite.play("default")
			velocity = Vector3.ZERO
	else:
		var input_dir = Vector3.ZERO
		
		if Input.is_action_just_pressed("move_up"):
			input_dir = Vector3.FORWARD  
			
		elif Input.is_action_just_pressed("move_down"):
			input_dir = Vector3.BACK
			
		elif Input.is_action_just_pressed("move_left"):
			input_dir = Vector3.LEFT
			
		elif Input.is_action_just_pressed("move_right"):
			input_dir = Vector3.RIGHT
			
		if input_dir != Vector3.ZERO and can_move_in_direction(input_dir) and can_control:
			start_dash(input_dir)
			GameEvents.on_player_move.emit(position, position + input_dir)

func start_dash(direction: Vector3) -> void:
	sprite.play("dash")
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		position,
		position + direction * 0.5
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		is_dashing = true
		dash_direction = direction

# Helper function to check if can move in a direction
func can_move_in_direction(direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		position,
		position + direction * 0.5
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	return result.is_empty()


func _on_hurtbox_area_3d_body_entered(body) -> void:
	if body.is_in_group("mob"):
		GameEvents.on_player_death.emit()
		
func _on_transition_start() -> void:
	can_control = false

func _on_transition_complete() -> void:
	can_control = true
	
func _on_game_start() -> void:
	can_control = true
	
func _on_player_death() -> void:
	can_control = false
	
