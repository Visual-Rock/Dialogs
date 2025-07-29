@tool
extends ConfirmationDialog

@onready var dialog_name: LineEdit = $VBoxContainer/DialogName
@onready var dialog_id: SpinBox = $VBoxContainer/DialogId
@onready var dialog_template: OptionButton = $VBoxContainer/Template

var context: DialogsContext

signal create_dialog_closed(result : CreateDialogResult)

func open_dialog() -> void:
	dialog_template.clear()
	
	var i := 0
	for template in context.templates:
		dialog_template.add_item(template.name)
		dialog_template.set_item_metadata(i, template)
		i += 1
	
	self.popup_centered()

func _on_confirmed() -> void:
	emit_signal("create_dialog_closed", CreateDialogResult.new(dialog_id.value, dialog_name.text, get_selected_template()))
	dialog_name.text = ""
	dialog_id.value += 1

func _on_canceled() -> void:
	emit_signal("create_dialog_closed", null)
	dialog_name.text = ""

func get_selected_template() -> Template:
	return dialog_template.get_selected_metadata()
