extends "./property.gd"

const _StringNameValidator := preload("../validators/string_name_validator.gd")
const _StringNameProperty := preload("./string_name_property.gd")

var _validator := _StringNameValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _StringNameProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: StringName) -> _StringNameProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min(new_min_length: int) -> _StringNameProperty:
	_validator.set_min(new_min_length)

	return self


func set_max(new_max_length: int) -> _StringNameProperty:
	_validator.set_max(new_max_length)

	return self


func set_pattern(new_pattern: StringName) -> _StringNameProperty:
	_validator.set_pattern(new_pattern)

	return self
