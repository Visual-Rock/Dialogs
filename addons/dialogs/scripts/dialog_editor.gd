@tool
extends GraphEdit

var save_texture := EditorInterface.get_editor_theme().get_icon("Save", "EditorIcons")
var add_texture := EditorInterface.get_editor_theme().get_icon("ToolAddNode", "EditorIcons")
var close_texture := EditorInterface.get_editor_theme().get_icon("GuiClose", "EditorIcons")

var dialog: Dialog
var context: DialogsContext

var node_menu_items := [
	{"name": "node 1", "key": KEY_N, "id": 0}
]

func _ready() -> void:
	var toolbar := get_toolbar()
	if toolbar != null:
		# save button
		var save_button = TextureButton.new()
		save_button.texture_normal = save_texture
		save_button.tooltip_text = "saves the dialog"
		save_button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
		save_button.connect("pressed", on_save_clicked)
		toolbar.add_child(save_button)
		
		# node menu
		var node_menu := MenuButton.new()
		node_menu.tooltip_text = "node menu"
		node_menu.icon = add_texture
		node_menu.shortcut_in_tooltip = true
		
		for node in node_menu_items:
			node_menu.get_popup().add_item(node["name"], node["id"])
			node_menu.get_popup().set_item_shortcut(node["id"], create_shortcut(node["key"]))
		
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

func on_save_clicked() -> void:
	context.save_dialog_editor(dialog, self)

func on_close_clicked() -> void:
	on_save_clicked()
	self.queue_free()

func get_toolbar() -> HBoxContainer:
	var root: Control
	for child in self.get_children(true):
		if child.get_child_count() == 4:
			root = child 
	
	if root == null:
		return null
	
	var panel: PanelContainer
	for child in root.get_children(true):
		if child is PanelContainer:
			panel = child 
	
	if panel == null:
		print("panel not found")
		return null
	
	var bar: HBoxContainer
	for child in panel.get_children(true):
		if child is HBoxContainer:
			bar = child
	return bar

func create_shortcut(key: int) -> Shortcut:
	var shortcut: Shortcut = Shortcut.new()
	var input_key : InputEventKey = InputEventKey.new()
	
	input_key.keycode = key
	input_key.alt_pressed = true

	shortcut.events = [input_key]
	return shortcut
