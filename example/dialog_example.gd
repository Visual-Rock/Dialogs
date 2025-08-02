extends Control

var manager: DialogManager
var currernt_dialog: Dialog

@onready var dialog_selector: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/DialogSelector
@onready var next_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button

@onready var name_field: Label = $MarginContainer/VBoxContainer/Dialog/HBoxContainer/VBoxContainer/Name
@onready var text_field: Label = $MarginContainer/VBoxContainer/Dialog/HBoxContainer/VBoxContainer/Text

@onready var branches: VBoxContainer = $MarginContainer/VBoxContainer/Dialog/HBoxContainer/Branches

func _ready() -> void:
	manager = DialogManager.new()
	
	for dialog in manager.dialogs:
		dialog_selector.add_item(dialog)
	
	load_dialog(dialog_selector.selected)
	
	next_button.pressed.connect(func(): 
		if currernt_dialog.is_end():
			currernt_dialog.start()
			next_button.text = "Next"
		else:
			currernt_dialog.next()
	)

func load_dialog(idx: int) -> void:
	currernt_dialog = manager.load_dialog(manager.dialogs[idx])
	currernt_dialog.on_current_node_changed.connect(node_changed)
	currernt_dialog.start()

func node_changed() -> void:
	var vals = currernt_dialog.get_values()
	name_field.text = vals["name"]
	text_field.text = vals["text"]
	
	if currernt_dialog.is_branch():
		var values := currernt_dialog.get_branch_values()
		var i: int = 0
		for branch in values:
			var btn = Button.new()
			btn.text = branch
			btn.pressed.connect(func(): currernt_dialog.next(i))
			branches.add_child(btn)
			i += 1
	else:
		for child in branches.get_children():
			child.queue_free()
	
	if currernt_dialog.is_end():
		next_button.text = "Restart"
