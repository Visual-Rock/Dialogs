@tool
extends GraphNode

func _ready() -> void:
	self.connect("delete_request", on_delete_request)
	self.connect("resize_request", on_resize_request)

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
	pass
