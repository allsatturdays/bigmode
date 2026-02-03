extends BaseEnemy

@onready var raycast_1: RayCast3D = $RayCast3D
@onready var raycast_2: RayCast3D = $RayCast3D2
@onready var raycast_3: RayCast3D = $RayCast3D3


var is_active: bool = true
var direction_array: Array[Vector3] = [Vector3.LEFT,  Vector3.BACK,  Vector3.RIGHT,Vector3.FORWARD]
var current_direction: Vector3 
var current_index: int = 0

var is_sight_updated: bool = false

func enemy_ready() -> void:
	current_direction = direction_array[0]
	$LineOfSight.set_raycast($RayCast3D3)
	#$LineOfSight.update_line(position, Vector3.BACK)
	$LineOfSight.update_line()

func _physics_process(delta: float) -> void:
	if !is_sight_updated and raycast_3.is_colliding():
		$LineOfSight.update_line()
		is_sight_updated = true
		
	if(is_active):
		if raycast_1.is_colliding() and raycast_1.get_collider().is_in_group('player'):
			GameEvents.on_player_death.emit()
		if raycast_2.is_colliding() and raycast_2.get_collider().is_in_group('player'):
			GameEvents.on_player_death.emit()	
		

func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	rotate_y(deg_to_rad(90))
	await get_tree().create_timer(.1).timeout
	is_sight_updated = false
	#is_line_of_sight_made = false
	#current_index = (current_index+1) % 4
	#print(current_index)
	#current_direction = direction_array[current_index]
	#$LineOfSight.update_line($RayCast3D3.global_position, current_direction.rotated(Vector3.UP, deg_to_rad(90)))
	
			

func _on_player_death()-> void:
	is_active = false
