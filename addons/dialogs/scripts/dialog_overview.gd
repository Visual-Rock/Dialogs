@tool 
extends Control

var context: DialogsContext

@onready var toolbar: HBoxContainer = $TabContainer/Overview/MainContainer/ToolBar
@onready var dialog_list: GridContainer = $TabContainer/Overview/MainContainer/DialogList
@onready var dialog_editors: TabContainer = $TabContainer/Dialogs/TabContainer

func _ready() -> void:
	# TODO: read from disc
	context = DialogsContext.new()
	context.load_data()
	
	# setup toolbar
	toolbar.init(context)
	toolbar.connect("dialog_added", on_dialog_added)
	
	# setup dialog list
	dialog_list.init(context)
	dialog_list.connect("open_dialog", on_open_dialog)

func on_dialog_added(dialog: Dialog) -> void:
	dialog_list.refresh_list()

func on_open_dialog(dialog: Dialog) -> void:
	if is_opened(dialog):
		return
	var editor = context.get_dialog_editor(dialog)
	editor.name = dialog.name
	dialog_editors.add_child(editor)
	editor.init(dialog, context)

func is_opened(dialog: Dialog) -> bool:
	for child in dialog_editors.get_children():
		# TODO: use id
		if child.name == dialog.name:
			return true
	return false
