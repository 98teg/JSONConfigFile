extends "./validator.gd"

const _EnumValidator := preload("./enum_validator.gd")

const _type_name := "string"

var _values_map := {}


func set_custom_parsing(new_custom_parsing: Callable) -> _EnumValidator:
	_custom_parsing = new_custom_parsing

	return self


func add_value(name: StringName, value: int) -> _EnumValidator:
	_values_map[name] = value

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_STRING:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if not _values_map.has(value):
		msgs.append(_not_valid_value(value))

	return msgs


func _parse(value: Variant) -> int:
	return _values_map[value]


static func _not_valid_value(value: String) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":not_valid_value",
		"'%s' is not a valid value" % [value],
		{"value": value},
	)
