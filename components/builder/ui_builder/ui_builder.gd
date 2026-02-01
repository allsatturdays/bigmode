class_name UiBuilder
extends Builder


func _ready() -> void:
	customize = {}
	customize["SaveFileButton"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.975, "max_rotation_degrees": 1.25}
	}
	customize["CodeTextEdit"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.988, "max_rotation_degrees": 0.625}
	}

	initialize(Control, [Tree ])#, GameButton])
	#initialize(MenuButtonClass, [Tree ])#, GameButton])
