extends BaseEnemy
class_name SecurityEnemy

func _physics_process(delta: float) -> void:
	if is_moving:
		# Continue moving
		velocity = (move_direction * DASH_SPEED) 
		move_and_slide()
		
		# Check if we've hit a wall or obstacle
		if get_slide_collision_count() > 0:
			# Snap to grid position
			position = Vector3(
				round(position.x / GRID_SIZE) * GRID_SIZE,
				position.y,
				round(position.z / GRID_SIZE) * GRID_SIZE
			)
			is_moving = false
			velocity = Vector3.ZERO

# This enemy moves one step towards the player each turn
func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	if is_moving:
		is_moving = false
	
	# Get direction towards player
	var direction = get_direction_to(player_position)
	
	# Try to move towards player
	if can_move_in_direction(direction):
		start_move(direction)
	else:
		# If blocked, try other directions
		var alt_directions = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]
		alt_directions.erase(direction)
		
		for alt_dir in alt_directions:
			if can_move_in_direction(alt_dir):
				start_move(alt_dir)
				break
				
