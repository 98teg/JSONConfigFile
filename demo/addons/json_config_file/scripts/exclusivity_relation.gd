extends Object

const ExclusivityRelation := preload("./exclusivity_relation.gd")

var property_names: Array[StringName]
var one_is_required := false


func _init(new_property_names: Array[StringName], new_one_is_required: bool) -> void:
	property_names = new_property_names
	one_is_required = new_one_is_required
