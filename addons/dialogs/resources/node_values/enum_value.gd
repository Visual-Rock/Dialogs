class_name EnumValue extends BaseValue

var values: Array[String] = []
var default: String

func _init(dict: Dictionary) -> void:
	type = NODEVALUETYPE.ENUM
	for val in dict["values"]:
		values.append(val)
	
	if dict.has("default"):
		default = dict["default"]
	else:
		default = values[0]
