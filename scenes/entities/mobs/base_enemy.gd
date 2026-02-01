extends CharacterBody3D
class_name BaseEnemy

var DASH_SPEED: float = 10.0
const GRID_SIZE: float = .5

var is_moving: bool = false
var move_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Snap to grid on start
	position = Vector3(
		round(position.x / GRID_SIZE) * GRID_SIZE,
		position.y,
		round(position.z / GRID_SIZE) * GRID_SIZE
	)
	
	# Connect to the GameEvents signal
	GameEvents.on_player_move.connect(_on_player_move)

# Override this method in child classes for different behaviors
func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
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
