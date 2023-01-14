extends "./validator.gd"

const _StringNameValidator := preload("./string_name_validator.gd")
const _StringValidator := preload("./string_validator.gd")

var _string_validator := _StringValidator.new()


func set_min(new_min_length: int) -> _StringNameValidator:
	_string_validator.set_min(new_min_length)

	return self


func set_max(new_max_length: int) -> _StringNameValidator:
	_string_validator.set_max(new_max_length)

	return self


func set_pattern(new_pattern: String) -> _StringNameValidator:
	_string_validator.set_pattern(new_pattern)

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _string_validator._validate(value)


func _parse(value: Variant) -> StringName:
	return value
