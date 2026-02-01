extends Node3D
class_name StageHazard

var is_hazard_active: bool = true
@onready var hurtbox: Area3D = $HurtBox
@onready var spike_container: Node3D = $SpikeContainer


func _ready() -> void:
	GameEvents.connect('on_player_move', _on_player_move)
	

func _on_player_move(player_start_position: Vector3, player_direction_position: Vector3) -> void:
	is_hazard_active = not is_hazard_active
	
	if is_hazard_active:
		hurtbox.monitoring = true 
		spike_container.visible = true
	else:
		hurtbox.monitoring = false 
		spike_container.visible = false
	


func _on_hurt_box_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.on_player_death.emit()
