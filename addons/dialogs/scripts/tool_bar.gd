@tool
extends Control

var context: DialogsContext

# Buttons
@onready var add_button = $Add
@onready var save_button = $Save

# Dialogs
@onready var create_dialog = $Dialogs/CreateDialog

# Textures
var add_texture: Texture2D = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")
var save_texture: Texture2D = EditorInterface.get_editor_theme().get_icon("Save", "EditorIcons")

# Signals
signal dialog_added(dialog: DialogInternal)

func init(context: DialogsContext) -> void:
	self.context = context
	
	add_button.texture_normal = add_texture
	add_button.connect("pressed", on_add_pressed)
	
	save_button.texture_normal = save_texture
	save_button.connect("pressed", on_save_pressed)
	
	create_dialog.context = context

func on_add_pressed() -> void:
	create_dialog.open_dialog()
	var result : CreateDialogResult = await create_dialog.create_dialog_closed
	
	if result == null:
		return
	
	var dialog = DialogInternal.new(result.dialog_id, result.dialog_name)
	dialog.template = result.dialog_template
	context.dialogs.append(dialog)
	emit_signal("dialog_added", dialog)

func on_save_pressed() -> void:
	context.save_data()
