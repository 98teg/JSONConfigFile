extends Object

const DependencyRelation := preload("./dependency_relation.gd")

var main_property_name: StringName
var dependent_property_name: StringName


func _init(new_main_property_name: StringName, new_dependent_property_name: StringName) -> void:
	main_property_name = new_main_property_name
	dependent_property_name = new_dependent_property_name
