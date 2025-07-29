@tool
extends GraphNode

@export var title_string: String = "Base Node"
@export var data: Dictionary = {}

@onready var values: VBoxContainer = $Values

var close_texture := EditorInterface.get_editor_theme().get_icon("GuiClose", "EditorIcons")

var template: Template

func _ready() -> void:
	self.connect("delete_request", on_delete_request)
	self.connect("resize_request", on_resize_request)
	
	var close_button := TextureButton.new()
	close_button.texture_normal = close_texture
	close_button.pressed.connect(on_delete_request)
	get_titlebar_hbox().add_child(close_button)
	
	title = title_string
	
	print("ready")

func init(t: Template) -> void:
	self.template = t
	add_values()

func on_delete_request() -> void:
	on_close()
	self.queue_free()

func on_resize_request(new_size: Vector2) -> void:
	self.size = new_size
	on_resize(new_size)

func on_close() -> void:
	pass

func on_resize(new_size: Vector2) -> void:
	pass

func save_and_set_owner(new_owner : Node) -> void:
	self.owner = new_owner
	save_node()

func save_node() -> void:
	for child in values.get_children():
		var template_value: BaseValue
		for v in template.values:
			if v.name == child.name:
				template_value = v
		print("saving value " + child.name)
		match template_value.type:
			0: # TODO: use enm value
				data[child.name] = child.get_selected_metadata()

func add_values() -> void:
	#for child in values.get_children():
	
	for value in template.values:
		var val
		if data.has(value.name):
			val = data[value.name]
		
		match value.type:
			0: # TODO: use enm value
				var btn = OptionButton.new()
				var default = -1
				var selected = -1
				var i := 0
				for entry in value.values:
					btn.add_item(entry)
					btn.set_item_metadata(i, entry)
					
					if val == entry:
						selected = i
					if value.default == entry:
						default = i
					i += 1
				
				if selected == -1:
					selected = default
				
				btn.select(selected)
				btn.name = value.name
				values.add_child(btn)
