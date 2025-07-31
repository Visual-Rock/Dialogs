@tool
extends GraphEdit

var save_texture := EditorInterface.get_editor_theme().get_icon("Save", "EditorIcons")
var add_texture := EditorInterface.get_editor_theme().get_icon("ToolAddNode", "EditorIcons")
var close_texture := EditorInterface.get_editor_theme().get_icon("GuiClose", "EditorIcons")
var bake_texture := EditorInterface.get_editor_theme().get_icon("Bake", "EditorIcons")

var node_menu: MenuButton
var start_node: GraphNode

var dialog: Dialog
var context: DialogsContext

var node_menu_items := [
	{
		"name": "Start Node",
		"key": KEY_S,
		"id": 0,
		"data": preload("res://addons/dialogs/ui/editor/nodes/start_node.tscn")
	},
	{
		"name": "Text Node",
		"key": KEY_T,
		"id": 1,
		"data": preload("res://addons/dialogs/ui/editor/nodes/text_node.tscn")
	},
	{
		"name": "Branch Node",
		"key": KEY_B,
		"id": 2,
		"data": preload("res://addons/dialogs/ui/editor/nodes/branch_node.tscn")
	},
	{
		"name": "End Node",
		"key": KEY_E,
		"id": 3,
		"data": preload("res://addons/dialogs/ui/editor/nodes/end_node.tscn")
	}
]

func _ready() -> void:
	var toolbar := get_menu_hbox()
	# save button
	var save_button = TextureButton.new()
	save_button.texture_normal = save_texture
	save_button.tooltip_text = "saves the dialog"
	save_button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
	save_button.connect("pressed", on_save_clicked)
	toolbar.add_child(save_button)
	
	# bake button
	var bake_button = TextureButton.new()
	bake_button.texture_normal = bake_texture
	bake_button.tooltip_text = "bakes the dialog"
	bake_button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
	bake_button.connect("pressed", on_bake_clicked)
	toolbar.add_child(bake_button)
	
	# node menu
	node_menu = MenuButton.new()
	node_menu.tooltip_text = "node menu"
	node_menu.icon = add_texture
	node_menu.shortcut_in_tooltip = true
	node_menu.get_popup().index_pressed.connect(on_add_node)
	
	for node in node_menu_items:
		node_menu.get_popup().add_item(node["name"], node["id"])
		node_menu.get_popup().set_item_shortcut(node["id"], create_shortcut(node["key"]))
		node_menu.get_popup().set_item_metadata(node["id"], node)
	
	toolbar.add_child(node_menu)
	
	# close button
	var close_button = TextureButton.new()
	close_button.texture_normal = close_texture
	close_button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
	close_button.tooltip_text = "saves and closes the dialog"
	close_button.connect("pressed", on_close_clicked)
	toolbar.add_child(close_button)
	
	self.connect("connection_request", connection_request)
	self.connect("disconnection_request", disconnection_request)
	
	for node in self.get_children():
		if node is GraphNode && node.node_type == 0:
			start_node = node

func connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)

func disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)

func init(dialog: Dialog, context: DialogsContext) -> void:
	self.dialog = dialog
	self.context = context
	
	for node in self.get_children():
		if node is GraphNode:
			node.init(dialog.template)

func on_save_clicked() -> void:
	context.save_dialog_editor(dialog, self)

func on_bake_clicked() -> void:
	if start_node == null:
		printerr("missing start node")
		return
	
	context.save_dialog_editor(dialog, self)
	
	var data: Dictionary  = {"name": dialog.name, "description": dialog.description}
	var nodes: Dictionary = {}
	var mapping: Dictionary = {}
	
	write_node(start_node, nodes, mapping, 1)
	
	data["nodes"] = nodes
	context.save_bake(data, dialog)

func on_add_node(id: int) -> void:
	var meta = node_menu.get_popup().get_item_metadata(id)
	# TODO: disable menu entry + message
	if start_node != null && meta["id"] == 0:
		return
	
	var node = meta["data"].instantiate()
	self.add_child(node)
	node.init(dialog.template)

func on_close_clicked() -> void:
	on_save_clicked()
	self.queue_free()

func create_shortcut(key: int) -> Shortcut:
	var shortcut: Shortcut = Shortcut.new()
	var input_key : InputEventKey = InputEventKey.new()
	
	input_key.keycode = key
	input_key.alt_pressed = true

	shortcut.events = [input_key]
	return shortcut

func write_node(node: GraphNode, nodes: Dictionary, mapping: Dictionary, id: int) -> void:
	var node_connections = self.get_connection_list_from_node(node.name).filter( func (conn: Dictionary) -> bool: return conn["from_node"] == node.name )
	node_connections.sort_custom( func(a, b): return a["from_port"] < b["from_port"] )
	
	var node_data: Dictionary = {
		"id": str(id),
		"type": node.node_type,
		"values": node.data
	}
	mapping[node.name] = id
	
	# branch node
	if node.node_type == 2:
		var branches = []
		var i = 0
		for branch in node.branches:
			var b = {"value": branch}
			
			# get next node
			var conn = node_connections.filter( func (conn: Dictionary) -> bool: return conn["from_port"] == i )
			if conn.size() == 1:
				var n = get_node_by_name(conn[0]["to_node"])
				b["next"] = str(get_node_id(n, nodes, mapping, id))
			
			branches.append(b)
			i += 1
		
		node_data["branches"] = branches
		node_data["branch_type"] = node.type
		if node.type == 2:
			node_data["value_name"] = node.value
	# End Node
	elif node.node_type == 3:
		pass
	else:
		var n = get_node_by_name(node_connections[0]["to_node"])
		node_data["next"] = str(get_node_id(n, nodes, mapping, id))
	
	nodes[str(id)] = node_data

func get_node_id(node: GraphNode, nodes: Dictionary, mapping: Dictionary, id: int) -> int:
	
	if mapping.has(node.name):
		return mapping[node.name]
	
	write_node(node, nodes, mapping, id + 1)
	return id + 1

func get_node_by_name(node: String) -> GraphNode:
	for child in self.get_children():
		if child.name == node:
			return child
	return null
