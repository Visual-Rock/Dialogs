@tool
extends ConfirmationDialog

@onready var dialog_name : LineEdit = $VBoxContainer/DialogName

signal create_dialog_closed(result : CreateDialogResult)

func open_dialog() -> void:
	self.popup_centered()

func _on_confirmed() -> void:
	emit_signal("create_dialog_closed", CreateDialogResult.new(dialog_name.text))
	dialog_name.text = ""

func _on_canceled() -> void:
	emit_signal("create_dialog_closed", null)
	dialog_name.text = ""
