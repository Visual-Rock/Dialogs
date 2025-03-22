@tool
extends EditorPlugin

const overview = preload("res://addons/dialogs/ui/overview/dialog_overview.tscn")

var overview_instance

func _enter_tree() -> void:
	overview_instance = overview.instantiate()
	
	EditorInterface.get_editor_main_screen().add_child(overview_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if overview_instance:
		overview_instance.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if overview_instance:
		overview_instance.visible = visible

func _get_plugin_name():
	return "Dialogs"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
