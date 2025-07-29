class_name Template extends Resource

var name: String

# TODO: rework to dictionary with name as key
var values: Array[BaseValue] = []

func _init(path: String) -> void:
	if !FileAccess.file_exists(path):
		return
	
	var f := FileAccess.open(path, FileAccess.READ)
	var file_content := f.get_as_text()
	
	var json := JSON.new()
	var error := json.parse(file_content)
	
	name = json.data["name"]
	for value in json.data["values"]:
		values.append(BaseValue.load_from_dict(value))
