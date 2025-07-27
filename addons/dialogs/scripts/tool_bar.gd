@tool
extends Control

@onready var add_button = $Add

# Dialogs
@onready var create_dialog = $Dialogs/CreateDialog

var add_texture: Texture2D = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")

func _ready() -> void:
	add_button.texture_normal = add_texture
	add_button.connect("pressed", on_add_pressed)

func on_add_pressed() -> void:
	create_dialog.open_dialog()
	var result : CreateDialogResult = await create_dialog.create_dialog_closed
	
	if result == null:
		return
	
	print(result.dialog_name)
	# TODO: create dialog
