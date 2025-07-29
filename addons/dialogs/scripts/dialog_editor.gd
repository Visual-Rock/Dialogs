@tool
extends GraphEdit

var save_texture := EditorInterface.get_editor_theme().get_icon("Save", "EditorIcons")
var add_texture := EditorInterface.get_editor_theme().get_icon("ToolAddNode", "EditorIcons")
var close_texture := EditorInterface.get_editor_theme().get_icon("GuiClose", "EditorIcons")

var node_menu: MenuButton

var dialog: Dialog
var context: DialogsContext

var node_menu_items := [
	{
		"name": "Text Node",
		"key": KEY_T,
		"id": 0,
		"data": preload("res://addons/dialogs/ui/editor/nodes/text_node.tscn")
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

func init(dialog: Dialog, context: DialogsContext) -> void:
	self.dialog = dialog
	self.context = context
	
	for node in self.get_children():
		if node is GraphNode:
			node.init(dialog.template)

func on_save_clicked() -> void:
	context.save_dialog_editor(dialog, self)

func on_add_node(id: int) -> void:
	var node = node_menu.get_popup().get_item_metadata(id)["data"].instantiate()
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
