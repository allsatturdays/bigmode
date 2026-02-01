extends Motion
class_name ScaleMotion


func _ready() -> void:
	super.initialize(Control)


func _motion_transform(target: Node) -> void:
	target.scale = _original_target_values[target] * motion_factor


func _set_target_original_values(target: Node) -> void:
	_original_target_values[target] = target.scale
