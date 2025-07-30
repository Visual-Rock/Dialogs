@tool
extends "res://addons/dialogs/scripts/nodes/base_node.gd"

@export var branches: Array = []
@export var type: int = 0
@export var value: String = ""

@onready var branch_box: SpinBox = $Header/Branches
@onready var branch_type: OptionButton = $Header/BranchType
@onready var value_name: LineEdit = $Header/ValueName

func on_init() -> void:
	if !branches.is_empty():
		branch_box.value = branches.size()
	
	value_name.text = value
	branch_type.select(type)
	on_type_changed(type)
	
	branch_type.connect("item_selected", on_type_changed)
	branch_box.connect("value_changed", on_branch_count_changed)

func on_save() -> void:
	value = value_name.text
	type = branch_type.get_selected_id()
	
	write_branches()

func on_type_changed(idx: int) -> void:
	update_branches(idx)

func on_branch_count_changed(value: float) -> void:
	update_branches(branch_type.get_selected_id())

func update_branches(idx: int) -> void:
	if idx == 2: # On Value
		value_name.visible = true
	else:
		value_name.visible = false
		value_name.text = ""
	
	for child in self.get_children():
		if child.name.begins_with("branch_"):
			self.remove_child(child)
			child.queue_free()
	
	for i in range(0, branch_box.value):
		var val = null
		if branches.size() > i:
			val = branches[i]
		else:
			val = 0 if branch_type.get_selected_id() == 1 else ""
		
		if branch_type.get_selected_id() == 1:
			var box: SpinBox = SpinBox.new()
			box.name = "branch_" + str(i)
			box.value = val
			self.add_child(box)
		else:
			var edit: LineEdit = LineEdit.new()
			edit.name = "branch_" + str(i)
			edit.text = val
			self.add_child(edit)
		
		set_slot_enabled_right(i + 3, true)

func write_branches() -> void:
	branches.clear()
	for child in self.get_children():
		if child.name.begins_with("branch_"):
			if child is SpinBox:
				branches.append(child.value)
			if child is LineEdit:
				branches.append(child.text)
