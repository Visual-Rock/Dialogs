class_name Dialog extends Resource

var id: int
var name: String
var description: String = ""
var template: Template

func _init(id: int, name: String) -> void:
	self.id = id
	self.name = name
