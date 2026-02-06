extends CharacterBody3D

@export var dash_speed: float = 60.0 * .5
@export var grid_size: float = .5
@export var new_room_control_freeze_time: float = .5 
@export var move_buffer_timer: float = .2
@export var sprite_offset_base: float = 100

var move_buffer: bool = false
var can_control: bool = false
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var input_dir: Vector3 = Vector3.ZERO
var buffer_dir: Vector3 = Vector3.ZERO
var player_z_coord: float
var last_anim: String = "test_dash_l"



@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var sfx_player: AudioStreamPlayer = $sfx_player



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
	player_z_coord = position.z

func _physics_process(delta: float) -> void:
	if not can_control:
		return
		
		
	if is_dashing:
		velocity = dash_direction * dash_speed
		move_and_slide()
		
		# movement stopped
		if get_slide_collision_count() > 0:
			# snap to grid	
			position = Vector3(
				round(position.x / grid_size) * grid_size,
				position.y,
				round(position.z / grid_size) * grid_size
			)
			# move buffer handle
			if can_move_in_direction(input_dir):
				if buffer_dir != dash_direction and move_buffer:
					if buffer_dir != Vector3.ZERO:
						move(buffer_dir)
						move_buffer = false
						
				else:
					is_dashing = false
					sprite.play("default")
					velocity = Vector3.ZERO
	
	
	#if move_buffer == true:
		#print(input_dir)
		#if input_dir != Vector3.ZERO and can_move_in_direction(input_dir):
			#print('move buffer success: ', input_dir)
			#move()
			#move_buffer = false

	input_dir = Vector3.ZERO
	
	if Input.is_action_just_pressed("move_up"):
		input_dir = Vector3.FORWARD  
		
	elif Input.is_action_just_pressed("move_down"):
		input_dir = Vector3.BACK
		
	elif Input.is_action_just_pressed("move_left"):
		input_dir = Vector3.LEFT
		
	elif Input.is_action_just_pressed("move_right"):
		input_dir = Vector3.RIGHT

	if input_dir != Vector3.ZERO:
		if !is_dashing and can_move_in_direction(input_dir):
			move(input_dir)
		else:
			buffer_dir = input_dir
			move_buffer = true
			get_tree().create_timer(move_buffer_timer).timeout.connect(_on_move_buffer_timeout)
		
		alter_sprite_offset()
	
	
func alter_sprite_offset() -> void: 
	#player_z_coord = position.z
	#sprite.sorting_offset = sprite_offset_base - player_z_coord
	#print(sprite.sorting_offset)
	pass

func move(dir: Vector3) -> void:
	start_dash(dir)
	sfx_player.play()


func start_dash(direction: Vector3) -> void:
	match(direction):
		Vector3.FORWARD:
			sprite.play("test_dash_l")
			last_anim = "test_dash_l"
		Vector3.BACK:
			sprite.play("test_dash_r")
			last_anim = "test_dash_r"
		Vector3.LEFT:
			sprite.play(last_anim)
		Vector3.RIGHT:
			sprite.play(last_anim)
	
	
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
		GameEvents.on_player_move.emit(position, position + input_dir)

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
	print(body)
	if body.is_in_group("mob"):
		GameEvents.on_player_death.emit()
		
func _on_transition_start() -> void:
	can_control = false

func _on_transition_complete() -> void:
	can_control = true
	
func _on_game_start() -> void:
	can_control = true
	Engine.time_scale = 1.0
	
func _on_player_death() -> void:
	can_control = false
	Engine.time_scale = 0.3
	
func _on_move_buffer_timeout() -> void:
	move_buffer = false
	
