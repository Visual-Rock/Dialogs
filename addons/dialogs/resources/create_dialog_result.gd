class_name CreateDialogResult extends Resource

var dialog_id: int
var dialog_name: String
var dialog_template: Template

func _init(id: int, name: String, template: Template) -> void:
	dialog_id = id
	dialog_name = name
	dialog_template = template
