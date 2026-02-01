extends BaseEnemy

@onready var raycast_1: RayCast3D = $RayCast3D
@onready var raycast_2: RayCast3D = $RayCast3D2

# added second raycast because player grid snapping can sometimes get by 
func _physics_process(delta: float) -> void:
	if raycast_1.is_colliding() and raycast_1.get_collider().is_in_group('player'):
		GameEvents.on_player_death.emit()
	if raycast_2.is_colliding() and raycast_2.get_collider().is_in_group('player'):
		GameEvents.on_player_death.emit()	
		

func _on_player_move(player_position: Vector3, player_move_direction: Vector3):
	rotate_y(deg_to_rad(90))
			
