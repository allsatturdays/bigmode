extends BaseEnemy
class_name StepperEnemy

var MOVE_SPEED = 30.0  # Faster speed for quick discrete movement
@export var steps_per_turn: int = 8  # Number of grid spaces to move

var target_position: Vector3 = Vector3.ZERO

func _ready():
	position = Vector3(
		round(position.x / GRID_SIZE) * GRID_SIZE,
		position.y,
		round(position.z / GRID_SIZE) * GRID_SIZE
	)
	target_position = position
	
	GameEvents.on_player_move.connect(_on_player_move)

func _physics_process(delta):
	if is_moving:
		# Move towards target position
		var direction_to_target = (target_position - position).normalized()
		velocity = direction_to_target * MOVE_SPEED
		
		# Check if we've reached the target or hit something
		var distance_to_target = position.distance_to(target_position)
		
		if distance_to_target < 0.1:
			# Reached target
			#position = target_position
			# Snap to grid position
			position = Vector3(
				round(position.x / GRID_SIZE) * GRID_SIZE,
				position.y,
				round(position.z / GRID_SIZE) * GRID_SIZE
			)
			velocity = Vector3.ZERO
			is_moving = false
		else:
			# Continue moving
			move_and_slide()
			
			# Check for collision
			if get_slide_collision_count() > 0:
				# Hit something, snap to grid and stop
				position = Vector3(
					round(position.x / GRID_SIZE) * GRID_SIZE,
					position.y,
					round(position.z / GRID_SIZE) * GRID_SIZE
				)
				apply_floor_snap()
				velocity = Vector3.ZERO
				is_moving = false

func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	#if is_moving:
		#return  # Still moving from last turn

	# Get direction towards player
	var direction = get_direction_to(player_position)
	
	# Calculate how many steps we can actually take
	var steps_to_take = calculate_valid_steps(direction, steps_per_turn)
	
	if steps_to_take > 0:
		# Set target position
		target_position = position + direction * GRID_SIZE * steps_to_take
		move_direction = direction
		is_moving = true


# Check how many steps we can take in a direction before hitting a wall
func calculate_valid_steps(direction: Vector3, max_steps: int) -> int:
	var space_state = get_world_3d().direct_space_state
	var valid_steps = 0
	
	for i in range(1, max_steps + 1):
		var check_position = position + direction * GRID_SIZE * i
		
		# Raycast to check if this position is valid
		var query = PhysicsRayQueryParameters3D.create(
			position + direction * GRID_SIZE * (i - 0.5),
			position + direction * GRID_SIZE * i
		)
		query.exclude = [self]
		
		var result = space_state.intersect_ray(query)
		
		if result.is_empty():
			valid_steps = i
		else:
			break  # Hit a wall, can't go further
	
	return valid_steps


#
