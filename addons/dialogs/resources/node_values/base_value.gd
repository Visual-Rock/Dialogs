class_name BaseValue extends Resource

enum NODEVALUETYPE {
	ENUM = 0
}

var name: String
var type: NODEVALUETYPE

static func load_from_dict(dict: Dictionary) -> BaseValue:
	var value: BaseValue
	match dict["type"]:
		"enum":
			value = EnumValue.new(dict)
	
	value.name = dict["name"]
	
	return value
