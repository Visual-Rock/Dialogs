class_name BoolValue extends BaseValue

var default: bool = false

func _init(dict: Dictionary) -> void:
	type = NODEVALUETYPE.BOOL
	
	if dict.has("default"):
		default = dict["default"]
