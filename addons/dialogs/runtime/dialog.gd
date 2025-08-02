class_name Dialog extends Object

var name: String
var description: String
var nodes: Dictionary
var history: Array[String] = []

# values used for branching and variable injection
var values: Dictionary
var auto_inject: bool = true

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
	if auto_inject:
		var v: Dictionary = current_node["values"];
		for key: String in v.keys():
			if v[key] is String:
				v[key] = inject(v[key])
		return v
	return current_node["values"]

func inject(string: String) -> String:
	# TODO: rework
	var rtrn: String = string
	var var_tags: int = string.count("<var>")
	var tag_start: int
	var tag_end: int
	var val_name: String
	for i in var_tags:
		tag_start = rtrn.find("<var>")
		tag_end  = rtrn.find("</var>")
		val_name = rtrn.substr(tag_start + 5, tag_end - 5 - tag_start)
		var tag: String = "<var>" + val_name + "</var>"
		if values.has(val_name):
			rtrn = rtrn.replace(tag, values[val_name])
		else:
			rtrn = rtrn.replace(tag, " ERR_VALUE_NOT_FOUND ")
	return rtrn
