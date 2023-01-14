extends "./property.gd"

const _StringValidator := preload("../validators/string_validator.gd")
const _StringProperty := preload("./string_property.gd")

var _validator := _StringValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _StringProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: String) -> _StringProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min(new_min_length: int) -> _StringProperty:
	_validator.set_min(new_min_length)

	return self


func set_max(new_max_length: int) -> _StringProperty:
	_validator.set_max(new_max_length)

	return self


func set_pattern(new_pattern: String) -> _StringProperty:
	_validator.set_pattern(new_pattern)

	return self
