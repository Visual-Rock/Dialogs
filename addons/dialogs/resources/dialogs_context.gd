@tool
class_name DialogsContext extends Resource

const PATH = "res://dialog"
const DATA_FILE_NAME = "data.json"

const EDITOR := preload("res://addons/dialogs/ui/editor/dialog_editor.tscn")

var dialogs: Array[DialogInternal] = []
var templates: Array[Template]     = []

func save_data() -> void:
	if !DirAccess.dir_exists_absolute(PATH):
		DirAccess.make_dir_recursive_absolute(PATH)
	
	var f := FileAccess.open(get_data_file_name(), FileAccess.WRITE)
	
	if f == null:
		print(FileAccess.get_open_error())
		return
	
	var data := { "dialogs": [] }
	
	for dialog in dialogs:
		data["dialogs"].append({ "id": dialog.id, "name": dialog.name, "description": dialog.description, "template": dialog.template.name })
	
	f.store_line(JSON.stringify(data))
	f.close()

func load_data() -> void:
	load_templates()
	
	if !FileAccess.file_exists(get_data_file_name()):
		return
	
	var f := FileAccess.open(get_data_file_name(), FileAccess.READ)
	var file_content := f.get_as_text()
	
	var json := JSON.new()
	var error := json.parse(file_content)
	
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file_content, " at line ", json.get_error_line())
		return
	
	var data : Dictionary = json.data
	
	if data.has("dialogs"):
		dialogs.clear()
		for dialog in data["dialogs"]:
			var d = DialogInternal.new(dialog["id"], dialog["name"])
			d.description = dialog["description"]
			d.template = get_template(dialog["template"])
			dialogs.append(d)

func get_template(name: String) -> Template:
	for template in templates:
		if template.name == name:
			return template
	printerr("failed to find template: " + name)
	return null

func save_bake(data: Dictionary, dailog: DialogInternal) -> void:
	DirAccess.make_dir_recursive_absolute(get_bake_file_name(dailog).get_base_dir())
	
	var f := FileAccess.open(get_bake_file_name(dailog), FileAccess.WRITE)
	
	if f == null:
		printerr(FileAccess.get_open_error())
		return
	
	f.store_line(JSON.stringify(data))
	f.close()

func get_data_file_name() -> String:
	return PATH + "/" + DATA_FILE_NAME

func get_bake_file_name(dialog: DialogInternal) -> String:
	return PATH + "/bakes/" + dialog.name + ".json"

func get_dialog_editor(dialog: DialogInternal) -> Control:
	if FileAccess.file_exists(get_dialog_editor_path(dialog)):
		return load(get_dialog_editor_path(dialog)).instantiate()
	return EDITOR.instantiate()

func save_dialog_editor(dialog: DialogInternal, editor: GraphEdit) -> void:
	var data := PackedScene.new()
	
	for child in editor.get_children():
		if child is GraphNode:
			child.save_and_set_owner(editor)
	
	DirAccess.make_dir_recursive_absolute(get_dialog_editor_path(dialog).get_base_dir())
	data.pack(editor)
	ResourceSaver.save(data, get_dialog_editor_path(dialog))

func get_dialog_editor_path(dialog: DialogInternal) -> String:
	return PATH + "/saves/" + str(dialog.id) + "_" + dialog.name + ".tscn"

func load_templates() -> void:
	if !DirAccess.dir_exists_absolute(get_templates_path()):
		printerr("no templates found! path: " + get_templates_path())
	
	for template in DirAccess.get_files_at(get_templates_path()):
		templates.append(Template.new(get_templates_path() + template))

func get_templates_path() -> String:
	return PATH + "/templates/" 
