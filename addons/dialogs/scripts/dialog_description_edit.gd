@tool
extends LineEdit

var dialog: DialogInternal

func _ready() -> void:
	self.text = dialog.description

func _on_text_changed(new_text: String) -> void:
	dialog.description = new_text
