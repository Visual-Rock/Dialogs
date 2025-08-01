class_name NumberValue extends BaseValue

var default: float = 0
var step: float = 1
var min: float = 0
var max: float = 100

func _init(dict: Dictionary) -> void:
	type = NODEVALUETYPE.NUMBER
	# TODO: refactor
	
	if dict.has("default"):
		default = dict["default"]
	
	if dict.has("step"):
		step = dict["step"]
	
	if dict.has("min"):
		min = dict["min"]
	
	if dict.has("max"):
		max = dict["max"]
