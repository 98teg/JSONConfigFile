extends Object
class_name JSONSchema

const _Property := preload("./scripts/properties/property.gd")
const _ExclusivityRelation := preload("./scripts/exclusivity_relation.gd")
const _DependencyRelation := preload("./scripts/dependency_relation.gd")
const _ValidationMsg := preload("./scripts/validation_msg.gd")

const _ArrayProperty := preload("./scripts/properties/array_property.gd")
const _BoolProperty := preload("./scripts/properties/bool_property.gd")
const _ColorProperty := preload("./scripts/properties/color_property.gd")
const _DictionaryProperty := preload("./scripts/properties/dictionary_property.gd")
const _EnumProperty := preload("./scripts/properties/enum_property.gd")
const _FileAccessProperty := preload("./scripts/properties/file_access_property.gd")
const _FloatProperty := preload("./scripts/properties/float_property.gd")
const _IntProperty := preload("./scripts/properties/int_property.gd")
const _JSONConfigFileProperty := preload("./scripts/properties/json_config_file_property.gd")
const _Rect2iProperty := preload("./scripts/properties/rect2i_property.gd")
const _Rect2Property := preload("./scripts/properties/rect2_property.gd")
const _StringNameProperty := preload("./scripts/properties/string_name_property.gd")
const _StringProperty := preload("./scripts/properties/string_property.gd")
const _Vector2iProperty := preload("./scripts/properties/vector2i_property.gd")
const _Vector2Property := preload("./scripts/properties/vector2_property.gd")
const _Vector3iProperty := preload("./scripts/properties/vector3i_property.gd")
const _Vector3Property := preload("./scripts/properties/vector3_property.gd")

const _type_name := "object"

var _properties := []
var _exclusivity_relations := []
var _dependency_relations := []


func add_array(name: StringName) -> _ArrayProperty:
	return _add_property(name, _ArrayProperty)


func add_bool(name: StringName) -> _BoolProperty:
	return _add_property(name, _BoolProperty)


func add_color(name: StringName) -> _ColorProperty:
	return _add_property(name, _ColorProperty)


func add_dictionary(name: StringName) -> _DictionaryProperty:
	return _add_property(name, _DictionaryProperty)


func add_enum(name: StringName) -> _EnumProperty:
	return _add_property(name, _EnumProperty)


func add_file_access(name: StringName) -> _FileAccessProperty:
	return _add_property(name, _FileAccessProperty)


func add_float(name: StringName) -> _FloatProperty:
	return _add_property(name, _FloatProperty)


func add_int(name: StringName) -> _IntProperty:
	return _add_property(name, _IntProperty)


func add_json_config_file(name: StringName) -> _JSONConfigFileProperty:
	return _add_property(name, _JSONConfigFileProperty)


func add_rect2i(name: StringName) -> _Rect2iProperty:
	return _add_property(name, _Rect2iProperty)


func add_rect2(name: StringName) -> _Rect2Property:
	return _add_property(name, _Rect2Property)


func add_string_name(name: StringName) -> _StringNameProperty:
	return _add_property(name, _StringNameProperty)


func add_string(name: StringName) -> _StringProperty:
	return _add_property(name, _StringProperty)


func add_vector2i(name: StringName) -> _Vector2iProperty:
	return _add_property(name, _Vector2iProperty)


func add_vector2(name: StringName) -> _Vector2Property:
	return _add_property(name, _Vector2Property)


func add_vector3i(name: StringName) -> _Vector3iProperty:
	return _add_property(name, _Vector3iProperty)


func add_vector3(name: StringName) -> _Vector3Property:
	return _add_property(name, _Vector3Property)


func _add_property(name: StringName, property_script: Script) -> Object:
	assert(not _property_exists(name))

	var property = property_script.new(name)

	_properties.append(property)

	return property


func add_exclusivity(property_names: Array[StringName], one_is_required := false) -> void:
	assert(property_names.all(func(name: StringName) -> bool: return _property_exists(name)))
	assert(property_names.all(
		func(name: StringName) -> bool: return _get_property_by_name(name)._required == false
	))

	_exclusivity_relations.append(_ExclusivityRelation.new(property_names, one_is_required))


func add_dependency(main_property_name: StringName, dependent_property_name: StringName) -> void:
	assert(_property_exists(main_property_name))
	assert(_get_property_by_name(main_property_name)._required == false)
	assert(_property_exists(dependent_property_name))
	assert(_get_property_by_name(dependent_property_name)._required == false)

	_dependency_relations.append(
		_DependencyRelation.new(main_property_name, dependent_property_name)
	)


func _property_exists(name: StringName) -> bool:
	return _properties.any(func(property: _Property) -> bool: return property._name == name)


func _get_property_by_name(name: StringName) -> _Property:
	assert(_property_exists(name))

	for property in _properties:
		if property._name == name:
			return property

	return null


func _get_dependent_property_names(main_property_name: StringName) -> Array[String]:
	var dependent_property_names: Array[String] = []

	for relation in _dependency_relations:
		if relation.main_property_name == main_property_name:
			dependent_property_names.append(relation.dependent_property_name)

	return dependent_property_names


func _validate(value: Variant, json_config_file_path := "") -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_DICTIONARY:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	for property in _properties:
		if value.has(property._name):
			var property_msgs: Array

			if property._validator._requires_json_config_file_path:
				property_msgs = property._validator._validate(
					value[property._name], json_config_file_path
				)
			else:
				property_msgs = property._validator._validate(value[property._name])

			for msg in property_msgs:
				msg._add_context_level(property._name)
				msgs.append(msg)

			for name in _get_dependent_property_names(property._name):
				if not value.has(name):
					msgs.append(_required_dependent_property_error(property._name, name))

		elif property._required:
			msgs.append(_required_property_error(property._name))

	for name in value.keys():
		if not _property_exists(name):
			msgs.append(_not_allowed_property_error(name))

	for exclusivity_relation in _exclusivity_relations:
		var defined_property_names: Array[StringName] = []

		for property_name in exclusivity_relation.property_names:
			if value.has(property_name):
				defined_property_names.append(property_name)

		if defined_property_names.size() < 1 and exclusivity_relation.one_is_required:
			msgs.append(_one_property_is_required_error(exclusivity_relation.property_names))
		elif defined_property_names.size() > 1:
			msgs.append(_exclusive_properties_error(defined_property_names))

	return msgs


func _parse(value: Variant, json_config_file_path := "") -> Dictionary:
	var result := Dictionary(value)

	for property in _properties:
		if result.has(property._name):
			if property._validator._requires_json_config_file_path:
				result[property._name] = property._validator._parse(
					result[property._name], json_config_file_path
				)
			else:
				result[property._name] = property._validator._parse(result[property._name])
		elif property._default_value != null:
			result[property._name] = property._default_value

	return result


static func _not_allowed_property_error(property: StringName) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":not_allowed_property",
		"Unkown property: '%s', this property is not allowed" % property,
		{"property": property},
	)


static func _required_property_error(property: StringName) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":required_property",
		"Missing property: '%s', this property is required" % property,
		{"property": property},
	)


static func _required_dependent_property_error(
	main_property: StringName, dependent_property: StringName
) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":required_dependent_property",
		"Missing property: '%s', this property is required if '%s' has been specified" % [
			dependent_property, main_property
		],
		{"main_property": main_property, "dependent_property": dependent_property},
	)


static func _one_property_is_required_error(properties: Array[StringName]) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":one_property_is_required",
		"One of this properties needs to be specified: %s" % _ValidationMsg._array_as_text(
			properties
		),
		{"properties": properties}
	)


static func _exclusive_properties_error(properties: Array[StringName]) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":exclusive_properties",
		"This properties can not be defined at the same time: %s" % _ValidationMsg._array_as_text(
			properties
		),
		{"properties": properties}
	)
