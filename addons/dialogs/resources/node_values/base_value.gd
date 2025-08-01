class_name BaseValue extends Resource

enum NODEVALUETYPE {
	ENUM = 0,
	NUMBER = 1,
	TEXT = 2
}

var name: String
var type: NODEVALUETYPE

static func load_from_dict(dict: Dictionary) -> BaseValue:
	var value: BaseValue
	match dict["type"]:
		"enum":
			value = EnumValue.new(dict)
		"number":
			value = NumberValue.new(dict)
		"text":
			value = TextValue.new(dict)
	
	value.name = dict["name"]
	
	return value
