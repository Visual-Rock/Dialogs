class_name Dialog extends Object

var name: String
var description: String
var nodes: Dictionary
var history: Array[String] = []

# values used for branching and variable injection
var values: Dictionary

var current_node: Dictionary = {}

signal on_current_node_changed()
signal end_reached()

func _init(data: Dictionary) -> void:
	name = data["name"]
	description = data["description"]
	nodes = data["nodes"]

func start() -> void:
	current_node = nodes["1"] 
	history = ["1"]
	on_current_node_changed.emit()

func next(branch_idx: int = 0) -> void:
	if is_branch():
		var branch = current_node["branches"][branch_idx]
		var next = branch["next"]
		current_node = nodes[next]
	else:
		var next = current_node["next"]
		current_node = nodes[next]
	
	if is_branch() && (current_node["branch_type"] == 1 || current_node["branch_type"] == 2):
		var idx: int = 0
		
		# Random
		if current_node["branch_type"] == 1:
			idx = randi_range(0, current_node["branches"].size() - 1)
		else:
			if values.has(current_node["value_name"]):
				var val = values[current_node["value_name"]]
				var i: int = 0
				for branch in get_branch_values():
					if branch == str(val):
						idx = i
						break
					i += 1
			else:
				printerr("no value with name " + current_node["value_name"] + "found")
		
		# dont emit node changed signal for the current node
		return next(idx)
	on_current_node_changed.emit()

func get_branch_values() -> Array:
	if !is_branch():
		return []
	var branches: Array = current_node["branches"]
	return branches.map(func(dict: Dictionary): return dict["value"])

func is_branch() -> bool:
	return current_node["type"] == 2

func is_end() -> bool:
	return current_node["type"] == 3

func get_values() -> Dictionary:
	return current_node["values"]
