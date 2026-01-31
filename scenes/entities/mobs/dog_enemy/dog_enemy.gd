#extends BaseEnemy
extends CharacterBody3D
class_name StepperEnemy

const GRID_SIZE = .5
const MOVE_SPEED = 30.0  # Faster speed for quick discrete movement

@export var steps_per_turn: int = 8  # Number of grid spaces to move

var is_moving = false
var target_position = Vector3.ZERO
var move_direction = Vector3.ZERO

func _ready():
	# Snap to grid on start
	position = Vector3(
		round(position.x / GRID_SIZE) * GRID_SIZE,
		position.y,
		round(position.z / GRID_SIZE) * GRID_SIZE
	)
	target_position = position
	
	# Connect to the GameEvents signal
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
			print(distance_to_target)
			# Continue moving
			move_and_slide()
			
			# Check for collision
			if get_slide_collision_count() > 0:
				print('asdfasdfs')
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

# Helper function to get direction towards a target position
func get_direction_to(target_pos: Vector3) -> Vector3:
	var diff = target_pos - position
	var abs_x = abs(diff.x)
	var abs_z = abs(diff.z)
	
	# Move in the direction with the larger difference
	if abs_x > abs_z:
		return Vector3.RIGHT if diff.x > 0 else Vector3.LEFT
	else:
		return Vector3.BACK if diff.z > 0 else Vector3.FORWARD

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


#class_name DogEnemy
#
## This enemy moves one step towards the player each turn
#
#func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	#if is_moving:
		#is_moving = false
	#
	## Get direction towards player
	#var direction = get_direction_to(player_position)
	#
	## Try to move towards player
	#if can_move_in_direction(direction):
		#start_move(direction)
	#else:
		## If blocked, try other directions
		#var alt_directions = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]
		#alt_directions.erase(direction)
		#
		#for alt_dir in alt_directions:
			#if can_move_in_direction(alt_dir):
				#start_move(alt_dir)
				#break
				#
