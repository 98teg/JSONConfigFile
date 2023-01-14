extends "./property.gd"

const _ArrayValidator := preload("../validators/array_validator.gd")
const _ArrayProperty := preload("./array_property.gd")

const _type_name := "array"

var _validator := _ArrayValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _ArrayProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Array) -> _ArrayProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min_size(new_min_size: int) -> _ArrayProperty:
	_validator.set_min_size(new_min_size)

	return self


func set_max_size(new_max_size: int) -> _ArrayProperty:
	_validator.set_max_size(new_max_size)

	return self


func enable_uniqueness(new_are_equal = null) -> _ArrayProperty:
	if new_are_equal == null:
		_validator.enable_uniqueness()
	else:
		_validator.enable_uniqueness(new_are_equal)

	return self


func with_array_elements() -> _ArrayValidator:
	return _validator.with_array_elements()


func with_bool_elements() -> _ArrayValidator._BoolValidator:
	return _validator.with_bool_elements()


func with_color_elements() -> _ArrayValidator._ColorValidator:
	return _validator.with_color_elements()


func with_dictionary_elements() -> _ArrayValidator._DictionaryValidator:
	return _validator.with_dictionary_elements()


func with_enum_elements() -> _ArrayValidator._EnumValidator:
	return _validator.with_enum_elements()


func with_file_access_elements() -> _ArrayValidator._FileAccessValidator:
	return _validator.with_file_access_elements()


func with_float_elements() -> _ArrayValidator._FloatValidator:
	return _validator.with_float_elements()


func with_int_elements() -> _ArrayValidator._IntValidator:
	return _validator.with_int_elements()


func with_json_config_file_elements() -> _ArrayValidator._JSONConfigFileValidator:
	return _validator.with_json_config_file_elements()


func with_rect2i_elements() -> _ArrayValidator._Rect2iValidator:
	return _validator.with_rect2i_elements()


func with_rect2_elements() -> _ArrayValidator._Rect2Validator:
	return _validator.with_rect2_elements()


func with_string_name_elements() -> _ArrayValidator._StringNameValidator:
	return _validator.with_string_name_elements()


func with_string_elements() -> _ArrayValidator._StringValidator:
	return _validator.with_string_elements()


func with_vector2i_elements() -> _ArrayValidator._Vector2iValidator:
	return _validator.with_vector2i_elements()


func with_vector2_elements() -> _ArrayValidator._Vector2Validator:
	return _validator.with_vector2_elements()


func with_vector3i_elements() -> _ArrayValidator._Vector3iValidator:
	return _validator.with_vector3i_elements()


func with_vector3_elements() -> _ArrayValidator._Vector3Validator:
	return _validator.with_vector3_elements()
