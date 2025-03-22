@tool
extends Control

@onready var add_button = $HBoxContainer/Add

var add_texture: Texture2D = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")

func _ready() -> void:
	add_button.texture_normal = add_texture
	add_button.connect("pressed", on_add_pressed)

func on_add_pressed() -> void:
	pass # TODO: add new dialog
