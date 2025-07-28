@tool
extends HBoxContainer

var dialog: Dialog

var open_texture: Texture2D = EditorInterface.get_editor_theme().get_icon("Play", "EditorIcons")

@onready var open_button := $OpenButton

signal open_dialog(dialog: Dialog)

func _ready() -> void:
	open_button.texture_normal = open_texture
	open_button.connect("pressed", on_open_dialog)

func on_open_dialog() -> void:
	emit_signal("open_dialog", dialog)
