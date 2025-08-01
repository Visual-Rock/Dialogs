class_name TextValue extends BaseValue

var multiline: bool
var default: String

func _init(dict: Dictionary) -> void:
	type = NODEVALUETYPE.TEXT
	
	multiline = dict["multiline"]
	if dict.has("default"):
		default = dict["default"]
