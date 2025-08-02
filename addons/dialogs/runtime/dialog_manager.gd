class_name DialogManager extends Object

const BASE_DIALOG_PATH = "res://dialog/bakes/"

var dialogs: Array[String] = []

func _init() -> void:
	for dialog in DirAccess.get_files_at(BASE_DIALOG_PATH):
		dialogs.append(dialog.get_file().replace("." + dialog.get_extension(), ""))

func load_dialog(name: String) -> Dialog:
	var path: String = BASE_DIALOG_PATH + name + ".json"
	if !FileAccess.file_exists(path):
		return null
	
	var f := FileAccess.open(path, FileAccess.READ)
	var file_content := f.get_as_text()
	
	var json := JSON.new()
	var error := json.parse(file_content)
	
	if error:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", file_content, " at line ", json.get_error_line())
		return null
	
	return Dialog.new(json.data)
