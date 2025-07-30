class_name NumberValue extends BaseValue

var default: float
var step: float
var min: float
var max: float

func _init(dict: Dictionary) -> void:
	type = NODEVALUETYPE.NUMBER
	# TODO: refactor
	
	if dict.has("default"):
		default = dict["default"]
	else:
		default = 0
	
	if dict.has("step"):
		step = dict["step"]
	else:
		step = 1
	
	if dict.has("min"):
		min = dict["min"]
	else:
		min = 0
	
	if dict.has("max"):
		max = dict["max"]
	else:
		max = 100
