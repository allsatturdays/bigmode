extends CharacterBody3D
class_name BaseEnemy

const DASH_SPEED = 10.0
const GRID_SIZE = .5

var is_moving: bool = false
var move_direction: Vector3 = Vector3.ZERO
var move_time: float = 0.5

@export var hurtbox: Area3D

func _ready():
	# Snap to grid on start
	position = Vector3(
		round(position.x / GRID_SIZE) * GRID_SIZE,
		position.y,
		round(position.z / GRID_SIZE) * GRID_SIZE
	)
	
	# Connect to the GameEvents signal
	GameEvents.on_player_move.connect(_on_player_move)

func _physics_process(delta):
	if is_moving:
		move_time -= delta 
		if(move_time <= 0.0):
			is_moving = false 
			move_time = 0.5
		else:
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

# Override this method in child classes for different behaviors
func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	# Default behavior: do nothing
	# Child classes should override this
	pass

# Helper function to start moving in a direction
func start_move(direction: Vector3):
	# Check if there's immediately a wall in that direction
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		position,
		position + direction * 0.5
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	# Only move if there's space
	if result.is_empty():
		is_moving = true
		move_direction = direction

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

# Helper function to get random cardinal direction
func get_random_direction() -> Vector3:
	var directions = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]
	return directions[randi() % directions.size()]

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
