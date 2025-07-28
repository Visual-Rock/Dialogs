@tool
extends GridContainer

enum COLUMN_TYPE {
	ID,
	NAME,
	DESCRIPTION,
	ACTIONS
}

var context: DialogsContext

var description_edit := preload("res://addons/dialogs/ui/overview/dialog_description_edit.tscn")
var action_buttons := preload("res://addons/dialogs/ui/overview/action_buttons.tscn")

signal open_dialog(dialog: Dialog)

func init(context: DialogsContext) -> void:
	self.context = context
	refresh_list()

func refresh_list() -> void:
	for child in self.get_children():
		if !child.name.begins_with("Header"):
			child.queue_free()
	
	for dialog in context.dialogs:
		for column in COLUMN_TYPE.values():
			var child: Control
			var suffix: String = str(column)
			
			match column:
				COLUMN_TYPE.ID:
					child = Label.new()
					child.text = str(dialog.id)
				COLUMN_TYPE.NAME:
					child = Label.new()
					child.text = dialog.name
				COLUMN_TYPE.DESCRIPTION:
					child = description_edit.instantiate()
					child.dialog = dialog
					child.text = dialog.description
				COLUMN_TYPE.ACTIONS:
					child = action_buttons.instantiate()
					child.dialog = dialog
					child.connect("open_dialog", on_open_dialog)
			
			child.name = str(dialog.id) + "_" + suffix
			self.add_child(child)

func on_open_dialog(dialog: Dialog) -> void:
	emit_signal("open_dialog", dialog)
