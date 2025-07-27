@tool 
extends Control

var context: DialogsContext

@onready var toolbar: HBoxContainer = $TabContainer/Overview/MainContainer/ToolBar
@onready var dialog_list: GridContainer = $TabContainer/Overview/MainContainer/DialogList

func _ready() -> void:
	# TODO: read from disc
	context = DialogsContext.new()
	context.load_data()
	
	# setup toolbar
	toolbar.context = context
	toolbar.connect("dialog_added", on_dialog_added)
	
	# setup dialog list
	dialog_list.init(context)

func on_dialog_added(dialog: Dialog) -> void:
	dialog_list.refresh_list()
